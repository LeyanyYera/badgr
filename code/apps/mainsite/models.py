import abc
import base64
from datetime import datetime, timedelta
from hashlib import sha1
import hmac
import uuid

from django.conf import settings
from django.core.urlresolvers import reverse
from django.db import models

from autoslug import AutoSlugField
import cachemodel
from jsonfield import JSONField

from .mixins import ResizeUploadedImage


AUTH_USER_MODEL = getattr(settings, 'AUTH_USER_MODEL', 'auth.User')


class AbstractComponent(cachemodel.CacheModel):
    """
    A base class for Issuer badge objects, those that are part of badges issue
    by users on this system.
    """
    created_at = models.DateTimeField(auto_now_add=True)
    created_by = models.ForeignKey(AUTH_USER_MODEL, blank=True, null=True,
                                   related_name="+")
    identifier = models.CharField(max_length=1024, null=False,
                                  default='get_full_url')
    json = JSONField()

    class Meta:
        abstract = True

    def __unicode__(self):
        return self.name

    def get_full_url(self):
        try:
            return self.json['id']
        except (KeyError, TypeError):
            if self.get_absolute_url().startswith('/'):
                return settings.HTTP_ORIGIN + self.get_absolute_url()
            else:
                return '_:null'

    def prop(self, property_name):
        return self.json.get(property_name)

    @property
    def owner(self):
        return self.created_by


class AbstractIssuer(ResizeUploadedImage, AbstractComponent):
    """
    Open Badges Specification IssuerOrg object
    """
    image = models.FileField(upload_to='uploads/issuers', blank=True,
                              null=True)
    name = models.CharField(max_length=1024)
    slug = AutoSlugField(max_length=255, populate_from='name', unique=True,
                         blank=False, editable=True)


    def get_absolute_url(self):
        return reverse('issuer_json', kwargs={'slug': self.slug})

    @property
    def editors(self):
        # TODO Test this:
        return self.staff.filter(issuerstaff__editor=True)

    class Meta:
        abstract = True

    def publish(self):
        super(AbstractIssuer, self).publish()
        self.publish_by('slug')

    def delete(self, *args, **kwargs):
        super(AbstractIssuer, self).delete(*args, **kwargs)
        self.publish_delete("slug")


class AbstractBadgeClass(ResizeUploadedImage, AbstractComponent):
    """
    Open Badges Specification BadgeClass object
    """
    #  issuer = models.ForeignKey(Issuer, blank=False, null=False,
    #                             on_delete=models.PROTECT,
    #                             related_name="badgeclasses")

    # Add family field in BadgeClass
    family = models.CharField(max_length=255)
    # Add category field in BadgeClass
    category = models.CharField(max_length=255)
    order = models.CharField(max_length=255)
    criteria_text = models.TextField(blank=True, null=True)  # TODO: CKEditor field
    image = models.FileField(upload_to='uploads/badges', blank=True)
    name = models.CharField(max_length=255)
    slug = AutoSlugField(max_length=255, populate_from='name', unique=True,
                         blank=False, editable=True)

    class Meta:
        abstract = True
        verbose_name_plural = "Badge classes"

    def get_absolute_url(self):
        return reverse('badgeclass_json', kwargs={'slug': self.slug})

    @property
    def owner(self):
        return self.issuer.owner

    def publish(self):
        super(AbstractBadgeClass, self).publish()
        self.publish_by('slug')

    def delete(self, *args, **kwargs):
        super(AbstractBadgeClass, self).delete(*args, **kwargs)
        self.publish_delete('slug')


class AbstractBadgeInstance(AbstractComponent):
    """
    Open Badges Specification Assertion object
    """
    # # 0.5 BadgeInstances have no notion of a BadgeClass (null=True)
    # badgeclass = models.ForeignKey(BadgeClass, blank=False, null=False,
    #                                on_delete=models.PROTECT,
    #                                related_name='assertions')
    # # 0.5 BadgeInstances have no notion of a BadgeClass (null=True)
    # issuer = models.ForeignKey(Issuer, blank=False, null=False)

    recipient_identifier = models.EmailField(max_length=1024, blank=False,
                                             null=False)
    expires = models.DateTimeField(blank=True, null=True)
    image = models.FileField(upload_to='uploads/badges', blank=True)  # upload_to='issued' in cred_store
    slug = AutoSlugField(max_length=255, populate_from='populate_slug',
                         unique=True, blank=False, editable=False)

    revoked = models.BooleanField(default=False)
    revocation_reason = models.CharField(max_length=255, blank=True, null=True,  # TODO: blank=True, null=True?
                                         default=None)

    class Meta:
        abstract = True

    def __unicode__(self):
        if self.badgeclass:
            badge_class_name = self.badgeclass.name
        else:
            badge_class_name = self.json['badge']['name']

        return "%s issued to %s" % (badge_class_name,
                                    self.recipient_identifier,)

    def get_absolute_url(self):
        return reverse('badgeinstance_json', kwargs={'slug': self.slug})

    def populate_slug(self):
        return str(uuid.uuid4())

    #  def image_url(self):
    #      if getattr(settings, 'MEDIA_URL').startswith('http'):
    #          return getattr(settings, 'MEDIA_URL') \
    #              + self.image.name
    #      else:
    #          return getattr(settings, 'HTTP_ORIGIN') \
    #              + getattr(settings, 'MEDIA_URL') \
    #              + self.image.name

    def publish(self):
        super(AbstractBadgeInstance, self).publish()
        self.publish_by('slug')
        self.publish_by('slug', 'revoked')

    def delete(self, *args, **kwargs):
        super(AbstractBadgeInstance, self).delete(*args, **kwargs)
        self.publish_delete('slug')
        self.publish_delete('slug', 'revoked')


class EmailBlacklist(models.Model):
    email = models.EmailField(unique=True)

    @staticmethod
    def generate_email_signature(email):
        secret_key = settings.UNSUBSCRIBE_SECRET_KEY

        expiration = datetime.utcnow() + timedelta(days=7)  # In one week.
        timestamp = int((expiration - datetime(1970, 1, 1)).total_seconds())

        email_encoded = base64.b64encode(email)
        hashed = hmac.new(secret_key, email_encoded + str(timestamp), sha1)

        return reverse('unsubscribe', kwargs={
            'email_encoded': email_encoded,
            'expiration': timestamp,
            'signature': hashed.hexdigest(),
        })

    @staticmethod
    def verify_email_signature(email_encoded, expiration, signature):
        secret_key = settings.UNSUBSCRIBE_SECRET_KEY

        hashed = hmac.new(secret_key, email_encoded + expiration, sha1)
        return hmac.compare_digest(hashed.hexdigest(), str(signature))


class AbstractFamilyClass(AbstractComponent):
    """
    Open Badges Specification FamilyClass object
    """
    #  issuer = models.ForeignKey(Issuer, blank=False, null=False,
    #                             on_delete=models.PROTECT,
    #                             related_name="familyclasses")

    name = models.CharField(max_length=255)
    slug = AutoSlugField(max_length=255, populate_from='name', unique=True,
                         blank=False, editable=True)

    class Meta:
        abstract = True
        verbose_name_plural = "Family classes"

    def get_absolute_url(self):
        return reverse('familyclass_json', kwargs={'slug': self.slug})

    @property
    def owner(self):
        return self.issuer.owner

    def publish(self):
        super(AbstractFamilyClass, self).publish()
        self.publish_by('slug')

    def delete(self, *args, **kwargs):
        super(AbstractFamilyClass, self).delete(*args, **kwargs)
        self.publish_delete('slug')


class AbstractCategoryClass(AbstractComponent):
    """
    Open Badges Specification FamilyClass object
    """
    #  family = models.ForeignKey(Family, blank=False, null=False,
    #                             on_delete=models.PROTECT,
    #                             related_name="familyclasses")

    name = models.CharField(max_length=255)
    slug = AutoSlugField(max_length=255, populate_from='name', unique=True,
                         blank=False, editable=True)

    class Meta:
        abstract = True
        verbose_name_plural = "Category classes"

    def get_absolute_url(self):
        return reverse('categoryclass_json', kwargs={'slug': self.slug})

    @property
    def owner(self):
        return self.issuer.owner

    def publish(self):
        super(AbstractCategoryClass, self).publish()
        self.publish_by('slug')

    def delete(self, *args, **kwargs):
        super(AbstractCategoryClass, self).delete(*args, **kwargs)
        self.publish_delete('slug')