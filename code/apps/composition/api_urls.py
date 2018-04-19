from django.conf.urls import patterns, url

from .api import (LocalBadgeInstanceList, LocalBadgeInstanceDetail,
                  CollectionList, CollectionDetail, CollectionGenerateShare,
                  CollectionLocalBadgeInstanceList,
                  CollectionLocalBadgeInstanceDetail)

urlpatterns = patterns(
    'issuer.api_views',
    url(r'^/badges$', LocalBadgeInstanceList.as_view(), name='localbadgeinstance_list'),
    url(r'^/badges/(?P<badge_id>[\d]+)$', LocalBadgeInstanceDetail.as_view(), name='localbadgeinstance_detail'),
    url(r'^/collections$', CollectionList.as_view(), name='collection_list'),
    url(r'^/collections/(?P<slug>[-\w]+)$', CollectionDetail.as_view(), name='collection_detail'),
    url(r'^/collections/(?P<slug>[-\w]+)/badges$', CollectionLocalBadgeInstanceList.as_view(), name='collection_badges'),
    url(r'^/collections/(?P<collection_slug>[-\w]+)/badges/(?P<badge_id>[\d]+)$', CollectionLocalBadgeInstanceDetail.as_view(), name='collection_localbadgeinstance_detail'),
    url(r'^/collections/(?P<slug>[-\w]+)/share$', CollectionGenerateShare.as_view(), name='collection_generate_share'),
)
