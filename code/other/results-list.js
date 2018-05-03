/**
 * Results List
 * Display results as an unordered list.
 * 
 */
YUI().add('gogo-results-list', function(Y) {
    var RESULTS_LIST = 'resultsList',
        SELECTOR_RESULT_CONTENT = '.details';
    
    function GoGoResultsList (config) {
        GoGoResultsList.superclass.constructor.apply(this, arguments);
    }
       
    Y.extend(GoGoResultsList, Y.GoGoResultsBase, {
        render: function () {
            this.renderUI();
            this.bindUI();
        },
        
        renderUI: function () {
            this.set(RESULTS_LIST, Y.Node.create('<ul></ul>').appendTo(this.get('srcNode')));
        },
        
        bindUI: function () {
            var sn = this.get('srcNode');
            Y.Global.on('gogosearch:loading', function (obj) {
                sn.addClass(this.getClassName('loading'));
            }, this);
            
            Y.Global.on('gogosearch:success', function (obj) {
                var list = this.get(RESULTS_LIST);
                // clear list if we're starting from the first result
                if (obj.start == 0)
                    list.empty();
                // append new results to the list
                Y.Object.each(obj.data, function (items, key) {
                    var template = this.get('items')[key];
                    if (template)
                        Y.Array.each(items.results, function (item) {
                            var li = Y.Node.create(Y.substitute(template, item, this.substitute));
                            li.addClass('item');
                            li.addClass(key);
                            li.addClass(item.source.name);
                            list.append(li);
                        }, this);
                }, this);
                sn.removeClass(this.getClassName('loading'));
                this.syncUI();
            }, this);
            
            // TODO: sensible response to failure.  A "no search items found" message?
            Y.Global.on('gogosearch:failure', function (obj) {
                sn.removeClass(this.getClassName('loading'));
            });
            
            // make layout flexible
            Y.on('windowresize', function (evt) {
                this.syncUI();
            }, this);
        },
        
        syncUI: function () {
            var lis = this.get(RESULTS_LIST).all(SELECTOR_RESULT_CONTENT);
            if (!lis.isEmpty()) {
                lis.setStyle('height', null);
                var height = lis.getStyle('height').reduce(function (a, b) {
                    return Math.max(parseInt(a), parseInt(b));
                });
                lis.setStyle('height', height);
            }
        }
    });
    
    GoGoResultsList.NAME = "gogo-results-list";
    GoGoResultsList.CSS_PREFIX = "gogo-results-list";
    Y.GoGoResultsList = GoGoResultsList;
}, '3.4.1', {
    requires: ['gogo-results-base']
});
