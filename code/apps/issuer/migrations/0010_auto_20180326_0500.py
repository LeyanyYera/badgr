# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import autoslug.fields
import jsonfield.fields
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('issuer', '0009_auto_20180323_1300'),
    ]

    operations = [
        migrations.CreateModel(
            name='CategoryClass',
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
                'abstract': False,
                'verbose_name_plural': 'Category classes',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='FamilyClass',
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
                'abstract': False,
                'verbose_name_plural': 'Family classes',
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='categoryclass',
            name='family',
            field=models.ForeignKey(related_name='categoryclasses', to='issuer.FamilyClass'),
            preserve_default=True,
        ),
    ]
