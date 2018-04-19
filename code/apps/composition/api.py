import os

from django.db import IntegrityError

from rest_framework import permissions, status, serializers
from rest_framework.response import Response
from rest_framework.views import APIView

import badgrlog
from mainsite.permissions import IsOwner

from .serializers import (LocalBadgeInstanceUploadSerializer,
                          CollectionSerializer,
                          CollectionLocalBadgeInstanceSerializer)
from .models import LocalBadgeInstance, Collection, LocalBadgeInstanceCollection

logger = badgrlog.BadgrLogger()


class LocalBadgeInstanceList(APIView):
    """
    Retrieve a list of the logged-in user's locally imported badges or post a
    new badge.
    """
    queryset = LocalBadgeInstance.objects.all()
    permission_classes = (permissions.IsAuthenticated, IsOwner,)

    def get(self, request):
        """
        GET a list of all the logged-in user's locally imported badges.
        ---
        serializer: LocalBadgeInstanceUploadSerializer
        """
        user_badges = self.queryset.filter(recipient_user=request.user)
        serializer = LocalBadgeInstanceUploadSerializer(
            user_badges, many=True, context={
                'request': request,
                'format': request.query_params.get('json_format', 'v1')
            })

        return Response(serializer.data)

    def post(self, request):
        """
        POST badge information to add a badge to the logged-in user's account.
        along with either a badge image file, hosted
        badge assertion URL, or badge assertion content itself.
        ---
        serializer: LocalBadgeInstanceUploadSerializer
        parameters:
            - name: image
              description: A baked badge image file
              required: false
              type: file
              paramType: form
            - name: assertion
              description: The signed or hosted assertion content, either as a JSON string or base64-encoded JWT
              required: false
              type: string
              paramType: form
            - name: url
              description: The URL of a hosted assertion
              required: false
              type: string
              paramType: form
        """
        serializer = LocalBadgeInstanceUploadSerializer(
            data=request.data, context={
                'request': request,
                'format': request.query_params.get('json_format', 'v1')
            })

        serializer.is_valid(raise_exception=True)

        serializer.save()

        return Response(serializer.data, status=status.HTTP_201_CREATED)


class LocalBadgeInstanceDetail(APIView):
    queryset = LocalBadgeInstance.objects.all()
    permission_classes = (permissions.IsAuthenticated,)
    """
    View or delete a locally imported badge earned by the logged-in user.
    """
    def get(self, request, badge_id):
        """
        GET details on one badge.
        ---
        serializer: LocalBadgeInstanceUploadSerializer
        parameters:
            - name: badge_id
              description: the unique id of the earner's badge to view
              required: true
              type: integer
              paramType: path
        """
        try:
            user_badge = self.queryset.get(recipient_user=request.user,
                                           id=badge_id)
        except LocalBadgeInstance.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        serializer = LocalBadgeInstanceUploadSerializer(user_badge, context={
            'request': request,
            'format': request.query_params.get('json_format', 'v1')
        })

        return Response(serializer.data)

    def delete(self, request, badge_id):
        """
        DELETE one stored badge from the logged-in earner's collection.
        ---
        parameters:
            - name: badge_id
              description: the unique id of the earner's badge to delete
              required: true
              type: integer
              paramType: path
        """
        try:
            self.queryset.get(
                recipient_user=request.user, id=badge_id
            ).delete()
        except LocalBadgeInstance.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        return Response(status=status.HTTP_204_NO_CONTENT)


class CollectionLocalBadgeInstanceList(APIView):
    """
    POST to add badges to collection, PUT to update collection to a new list of
    ids.
    """
    queryset = LocalBadgeInstanceCollection.objects.all()
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, slug):
        """
        GET the badges in a single Collection
        """
        collection_badges = self.queryset.filter(
            collection__slug=slug,
            instance__recipient_user=request.user)

        serializer = CollectionLocalBadgeInstanceSerializer(collection_badges,
                                                            many=True)
        return Response(serializer.data)

    def post(self, request, slug):
        """
        POST new badge(s) to add them to a existing Collection.
        Returns resulting complete list of collection contents.
        """
        try:
            collection = Collection.objects.get(owner=request.user, slug=slug)
        except (Collection.MultipleObjectsReturned, Collection.DoesNotExist):
            return Response("Badge collection %s not found." % slug,
                            status=status.HTTP_404_NOT_FOUND)

        add_many = isinstance(request.data, list)
        serializer = CollectionLocalBadgeInstanceSerializer(
            data=request.data, many=add_many,
            context={'collection': collection, 'request': request})
        serializer.is_valid(raise_exception=True)

        new_records = serializer.save()

        if new_records == []:
            return Response(
                "No new records could be added to collection. " +
                "Check for missing/unknown badge references, unauthorized " +
                "access, or badges already existing in collection.",
                status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def put(self, request, slug):
        """
        Update the list of badges included in a collection among
        those added to the logged-in user's badges. Cannot be used to
        change the description of a badge in the collection, but can
        be used to add descriptions to new badges to be added from the
        user's existing badges. Cannot be used to add new badges to the
        user's account at this time.
        ---
        parameters:
            - name: slug
              description: The collection's slug identifier
              required: true
              type: string
              paramType: path
            - name: badges
              description: A JSON serialization of all the badges to be included in this collection, replacing the list that currently exists.
              required: true
              paramType: body
        """
        badges = request.data

        try:
            collection = Collection.objects.get(
                owner=request.user,
                slug=slug)
        except Collection.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        serializer = CollectionLocalBadgeInstanceSerializer(
            data=badges, many=isinstance(badges, list),
            context={'collection': collection, 'request': request}
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()

        badge_ids = [
            item.get('id') for item in badges
        ]

        badges_to_remove = LocalBadgeInstanceCollection.objects.filter(
            collection=collection
        ).exclude(instance__id__in=badge_ids)
        for badge in badges_to_remove:
            badge.delete()

        serializer = CollectionLocalBadgeInstanceSerializer(
            collection.localbadgeinstancecollection_set.all(), many=True
        )
        return Response(serializer.data)


class CollectionLocalBadgeInstanceDetail(APIView):
    """
    Update details on a single item in the collection or remove it from the
    collection.
    """
    queryset = LocalBadgeInstanceCollection.objects.all()
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, collection_slug, badge_id):
        try:
            item = self.queryset.get(
                instance__recipient_user=request.user,
                collection__slug=collection_slug,
                instance__id=int(badge_id))
        except LocalBadgeInstanceCollection.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        serializer = CollectionLocalBadgeInstanceSerializer(item)
        return Response(serializer.data)

    def put(self, request, collection_slug, badge_id):
        """
        Update the description of a badge in a collection.
        ---
        parameters:
            - name: description
              description: Earner's annotation about a badge particular to this collection's audience.
              required: true
              type: string
              paramType: form
            - name: collection_slug
              description: The collection's slug identifier
              required: true
              type: string
              paramType: path
            - name: badge_id
              description: The stored badge's integer identifier
              required: true
              type: integer
              paramType: path
        """
        description = request.data.get('description', '')

        try:
            description = str(description)
        except TypeError:
            return serializers.ValidationError(
                "Server could not understand description")
        try:
            item = self.queryset.get(
                instance__recipient_user=request.user,
                collection__slug=collection_slug,
                instance__id=int(badge_id))
        except LocalBadgeInstanceCollection.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        item.description = description
        item.save()

        serializer = CollectionLocalBadgeInstanceSerializer(item)
        return Response(serializer.data)

    def delete(self, request, collection_slug, badge_id):
        """
        Remove a badge from a collection (does not delete it
        from the earner's account)
        ---
        parameters:
            - name: collection_slug
              description: The collection's slug identifier
              required: true
              type: string
              paramType: path
            - name: badge_id
              description: The stored badge's integer identifier
              required: true
              type: integer
              paramType: path
        """
        try:
            self.queryset.get(
                instance__recipient_user=request.user,
                collection__slug=collection_slug,
                instance__id=int(badge_id)
            ).delete()
        except LocalBadgeInstanceCollection.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        return Response(status=status.HTTP_204_NO_CONTENT)


class CollectionDetail(APIView):
    """
    View details of one Collection, update or delete it.
    """
    queryset = Collection.objects.all()
    permission_classes = (permissions.IsAuthenticated, IsOwner,)

    def get(self, request, slug):
        """
        GET a single collection details, by slug
        """
        try:
            user_collection = self.queryset.get(
                owner=request.user,
                slug=slug
            )
        except (Collection.MultipleObjectsReturned,
                Collection.DoesNotExist):
            return Response(status=status.HTTP_404_NOT_FOUND)

        else:
            serializer = CollectionSerializer(user_collection)
            return Response(serializer.data)

    def put(self, request, slug):
        """
        Update the description of a badge collection.
        ---
        serializer: CollectionSerializer
        parameters:
            - name: slug
              description: The collection's slug identifier
              required: true
              type: string
              paramType: path
            - name: description
              description: A description of the collection.
              required: false
              type: string
              paramType: form
        """
        name = request.data.get('name')
        description = request.data.get('description')
        try:
            name = str(name)
            description = str(description)
        except TypeError:
            return serializers.ValidationError(
                "Server could not understand PUT fields. Expected strings.")

        try:
            collection = self.queryset.get(
                owner=request.user,
                slug=slug
            )
        except Collection.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        if name:
            collection.name = name
        if description:
            collection.description = description

        collection.save()

        serializer = CollectionSerializer(collection)
        return Response(serializer.data)

    def delete(self, request, slug):
        """
        Delete a collection
        ---
        parameters:
            - name: slug
              description: "The collection's slug identifier"
              type: string
              paramType: path
        """
        try:
            user_collection = self.queryset.get(
                owner=request.user,
                slug=slug
            )
        except (Collection.MultipleObjectsReturned,
                Collection.DoesNotExist):
            return Response(status=status.HTTP_404_NOT_FOUND)

        else:
            user_collection.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)


class CollectionList(APIView):
    """
    Retrieve a list of Collections or post to create a new collection.
    """
    queryset = Collection.objects.all()
    permission_classes = (permissions.IsAuthenticated, IsOwner,)

    def get(self, request):
        """
        GET a list of the logged-in user's Collections.
        ---
        serializer: CollectionSerializer
        """
        user_collections = self.queryset.filter(owner=request.user)

        serializer = CollectionSerializer(user_collections, many=True,
                                          context={'request': request})

        return Response(serializer.data)

    def post(self, request):
        """
        POST a new collection to the logged-in user's account.
        ---
        serializer: CollectionSerializer
        """
        serializer = CollectionSerializer(data=request.data,
                                          context={'request': request})

        serializer.is_valid(raise_exception=True)
        try:
            serializer.save()
        except IntegrityError:
            return Response("A collection with this name already exists",
                            status=status.HTTP_400_BAD_REQUEST)

        return Response(serializer.data, status=status.HTTP_201_CREATED)


class CollectionGenerateShare(APIView):
    """
    Allows a Collection to be public by generation of a shareable hash.
    """
    queryset = Collection.objects.all()
    permission_classes = (permissions.IsAuthenticated, IsOwner,)

    def get(self, request, slug):
        try:
            collection = self.queryset.get(
                owner=request.user,
                slug=slug)
        except Collection.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        if not collection.share_hash:
            share_hash = os.urandom(16).encode('hex')
            collection.share_hash = share_hash
            collection.save()

        return Response(collection.share_url)

    def delete(self, request, slug):
        try:
            collection = self.queryset.get(
                owner=request.user,
                slug=slug)
        except Collection.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        collection.share_hash = ''
        collection.save()

        return Response(status=status.HTTP_204_NO_CONTENT)
