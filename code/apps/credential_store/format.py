from rest_framework import serializers

from integrity_verifier.serializers.fields import BadgeDateTimeField as BDTF


class BadgeURLField(serializers.URLField):
    def to_representation(self, value):
        if self.context.get('format', 'v1') == 'v1':
            result = {
                'type': '@id',
                'id': value
            }
            if self.context.get('name') is not None:
                result['name'] = self.context.get('name')
            return result
        else:
            return value


class BadgeImageURLField(serializers.URLField):
    def to_representation(self, value):
        if self.context.get('format', 'v1') == 'v1':
            result = {
                'type': 'image',
                'id': value
            }
            if self.context.get('name') is not None:
                result['name'] = self.context.get('name')
            return result
        else:
            return value


class BadgeStringField(serializers.CharField):
    def to_representation(self, value):
        if self.context.get('format', 'v1') == 'v1':
            return {
                'type': 'xsd:string',
                '@value': value
            }
        else:
            return value


class BadgeEmailField(serializers.EmailField):
    def to_representation(self, value):
        if self.context.get('format', 'v1') == 'v1':
            return {
                'type': 'email',
                '@value': value
            }
        else:
            return value


class BadgeDateTimeField(BDTF):
    def to_representation(self, string_value):
        value = super(BadgeDateTimeField, self).to_representation(string_value)
        if self.context.get('format', 'v1') == 'v1':
            return {
                'type': 'xsd:dateTime',
                '@value': value
            }
        else:
            return value


class V1IssuerSerializer(serializers.Serializer):
    id = serializers.URLField()
    type = serializers.CharField()
    name = BadgeStringField()
    url = BadgeURLField()
    description = BadgeStringField(required=False)
    image = BadgeImageURLField(required=False)
    email = BadgeEmailField(required=False)


class V1BadgeClassSerializer(serializers.Serializer):
    id = serializers.URLField()
    type = serializers.CharField()
    name = BadgeStringField()
    description = BadgeStringField()
    image = BadgeImageURLField()
    criteria = BadgeURLField()
    issuer = V1IssuerSerializer()
    # alignment = TODO
    tags = serializers.ListField(child=BadgeStringField(), required=False)


class V1InstanceSerializer(serializers.Serializer):
    id = serializers.URLField()
    type = serializers.CharField()
    uid = BadgeStringField(required=False)
    recipient = BadgeEmailField()  # TODO: improve for richer types
    badge = V1BadgeClassSerializer()
    issuedOn = BadgeDateTimeField()
    expires = BadgeDateTimeField(required=False)
    image = BadgeImageURLField(required=False)
    evidence = BadgeURLField(required=False)
