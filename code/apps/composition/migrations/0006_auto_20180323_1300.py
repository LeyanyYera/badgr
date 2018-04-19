# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import datetime
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('composition', '0005_auto_20151117_1555'),
    ]

    operations = [
        migrations.AddField(
            model_name='localbadgeclass',
            name='category',
            field=models.CharField(default=datetime.datetime(2018, 3, 23, 20, 0, 8, 262541, tzinfo=utc), max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='localbadgeclass',
            name='family',
            field=models.CharField(default=datetime.datetime(2018, 3, 23, 20, 0, 15, 398274, tzinfo=utc), max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='localbadgeclass',
            name='order',
            field=models.CharField(default=datetime.datetime(2018, 3, 23, 20, 0, 22, 422208, tzinfo=utc), max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='localbadgeinstance',
            name='expires',
            field=models.DateTimeField(null=True, blank=True),
            preserve_default=True,
        ),
    ]