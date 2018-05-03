from django.db import models
from piston.models import Consumer
from django.utils.translation import ugettext_lazy as _

class Source(Consumer):
    """
    A subclass of Piston's OAuth consumer that can create and edit items.
    """
    site_url = models.URLField(_('site url'), max_length=512, verify_exists=True)
    affiliate_url = models.URLField(_('affiliate url'), max_length=225, verify_exists=False, help_text=_('Link that tells the source to pay somebody.'))
    affiliate_code = models.CharField(_('affiliate code'), max_length=100, help_text=_('Unique ID that tells the source whom to pay.'))

    class Meta:
        unique_together = ('affiliate_url', 'affiliate_code')
        verbose_name = _('source')
        verbose_name_plural = _('sources')

    def __unicode__(self):
        return self.name


class Group(models.Model):
    slug = models.SlugField(_('slug'), editable=False, max_length=250, unique=True, help_text=_('A unique description that can be used to identify item groups in a GoGoGremlin url.'))
   
    class Meta:
        verbose_name = _('group')
        verbose_name_plural = _('groups')

    def __unicode__(self):
        return self.slug
    
    def item_sets(self):
        """
        Return a dictionary of all item_sets for this group.  Using this method we
        can easily refer to many items in different apps using one group.
        """
        item_sets = {}
        for sub in BaseItem.__subclasses__():
            app_name = sub.__module__.split('.')[-2].lower()
            model_name = sub.__name__.lower()
            item_sets[app_name] = getattr(self, '{0:s}_{1:s}_set'.format(app_name, model_name), None)
        return item_sets


class BaseItem(models.Model):
    source = models.ForeignKey(Source, editable=False, verbose_name=_('source'))
    groups = models.ManyToManyField(Group, related_name="%(app_label)s_%(class)s_set", verbose_name=_('group'))
    slug = models.SlugField(_('slug'), editable=False, max_length=250, unique=True, help_text=_('A unique description that can be used to identify items in a GoGoGremlin url.'))
    created_at = models.DateTimeField(_('created at'), auto_now=False, auto_now_add=True, db_index=True, editable=False, help_text=_('Date the item was discovered.'))

    class Meta:
        abstract = True
        verbose_name = _('item')
        verbose_name_plural = _('items')

    def __unicode__(self):
        return self.slug
    
    @models.permalink
    def get_absolute_url(self):
        return ('{0:s}:detail'.format(self.__module__.split('.')[-2]), (), {'slug': self.slug})
