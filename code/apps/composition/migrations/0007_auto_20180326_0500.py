# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import autoslug.fields
import jsonfield.fields
import django.db.models.deletion
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('composition', '0006_auto_20180323_1300'),
    ]

    operations = [
        migrations.CreateModel(
            name='LocalCategoryClass',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('identifier', models.CharField(default=b'get_full_url', max_length=1024)),
                ('json', jsonfield.fields.JSONField()),
                ('name', models.CharField(max_length=255)),
                ('slug', autoslug.fields.AutoSlugField(unique=True, max_length=255)),
                ('created_by', models.ForeignKey(related_name='+', blank=True, to=settings.AUTH_USER_MODEL, null=True)),
            ],
            options={
                'verbose_name': 'local category class',
                'verbose_name_plural': 'local category classes',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='LocalFamilyClass',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('identifier', models.CharField(default=b'get_full_url', max_length=1024)),
                ('json', jsonfield.fields.JSONField()),
                ('name', models.CharField(max_length=255)),
                ('slug', autoslug.fields.AutoSlugField(unique=True, max_length=255)),
                ('created_by', models.ForeignKey(related_name='+', blank=True, to=settings.AUTH_USER_MODEL, null=True)),
            ],
            options={
                'verbose_name': 'local family class',
                'verbose_name_plural': 'local family classes',
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='localcategoryclass',
            name='family',
            field=models.ForeignKey(related_name='categoryclasses', on_delete=django.db.models.deletion.PROTECT, to='composition.LocalFamilyClass'),
            preserve_default=True,
        ),
    ]
