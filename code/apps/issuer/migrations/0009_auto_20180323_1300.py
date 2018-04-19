# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import datetime
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('issuer', '0008_auto_20160322_1404'),
    ]

    operations = [
        migrations.AddField(
            model_name='badgeclass',
            name='category',
            field=models.CharField(default=datetime.datetime(2018, 3, 23, 20, 0, 38, 478019, tzinfo=utc), max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='badgeclass',
            name='family',
            field=models.CharField(default=datetime.datetime(2018, 3, 23, 20, 0, 46, 78828, tzinfo=utc), max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='badgeclass',
            name='order',
            field=models.CharField(default=datetime.datetime(2018, 3, 23, 20, 0, 53, 118152, tzinfo=utc), max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='badgeinstance',
            name='expires',
            field=models.DateTimeField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
