import csv
from cStringIO import StringIO
from django.utils.encoding import smart_unicode
from piston.emitters import Emitter

class AtomEmitter(Emitter):
    def render(self, request):
        data = self.construct()
        return data


class RSSEmitter(Emitter):
    def render(self, request):
        data = self.construct()
        return data


# The csv module has trouble with unicode.
# http://localhost/~barry/Programming/Python/2.7.2/library/csv.html#examples
class DelimitedEmitter(Emitter):
    delimiter = ','
    doublequote = False
    escapechar = '\\'
    lineterminator = '\n'
    header = True

    def _write_delimited(self, csvwriter, row):
        csvwriter.writerow(self._flatten(row))

    def _flatten(self, data={}, prefix=''):
        separator = ':' if prefix else ''
        flattened = {}
        for key, value in data.iteritems():
            if isinstance(value, dict):
                flattened.update(self._flatten(value, key))
            else:
                # encode in utf8 before writing
                flattened['{0:s}{1:s}{2:s}'.format(prefix, separator, key)] = smart_unicode(value).encode('utf8')
        return flattened

    def render(self, request):
        data = self.construct()
        # get header fields
        if isinstance(data, dict):
            data = [data]
        fieldnames = sorted(self._flatten(data[0]).keys())
        # create csv writer
        stream = StringIO()
        csvwriter = csv.DictWriter(
            stream, fieldnames, extrasaction='ignore', delimiter=self.delimiter, 
            doublequote=self.doublequote, escapechar=self.escapechar, lineterminator=self.lineterminator
        )
        # conditionally output header
        if self.header:
            csvwriter.writeheader()
        for row in data:
            self._write_delimited(csvwriter, row)
        # recode in unicode upon output
        return unicode(stream.getvalue(), 'utf8')

    
class CSVEmitter(DelimitedEmitter):
    delimiter=','
    
    
class TSVEmitter(DelimitedEmitter):
    delimiter='\t'


Emitter.register('atom', AtomEmitter, 'application/atom+xml; charset=utf-8')
Emitter.register('rss', RSSEmitter, 'application/rss+xml; charset=utf-8')
Emitter.register('csv', CSVEmitter, 'text/csv; charset=utf-8')
Emitter.register('tsv', TSVEmitter, 'text/tab-separated-values; charset=utf-8')
