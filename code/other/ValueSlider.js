var ValueSlider = Class.create(Widget, {
    name:  'ValueSlider',
    _index: 0,
    
    initialize: function ($super, domElement, initVal, maxVal, oneClick, onselect) {
        // setup as an unordered list
        $super(domElement);
        this.ul = $(document.createElement('ul'));
        this.element.insert(this.ul);

        // add the value buttons
        this.buttons  = new Array(maxVal || 5);
        for (var i = 0, length = this.buttons.length; i < length; i++)
            this.buttons[i] = new ValueSlider.Button(this);

        // initial selection
        this.value    = initVal;
        this.maxValue = maxVal;
        this.oneClick = Object.isUndefined(oneClick) ? true : oneClick;
        this.mouseOut(null);
        // return to initial selection on user mouseout
        this.setObserver('valueSliderMouseOut', 'mouseout', this.mouseOut);

        // what specific thing do we do when we're clicked?
        this.onselect = onselect ? onselect.bind(this) : null;
    },

    getValue: function () {
        return this.value;
    },

    setValue: function (value) {
        this.value = Math.max(0, Math.min(value, this.maxValue));
        this.mouseOut(null);
    },

    select: function (event, button) {
        this.value = button.getIndex() + 1;
        // handle final click
        if (this.oneClick) {
            for (var i = 0, length = this.buttons.length; i < length; i++) {
                var b = this.buttons[i];
                b[(i < this.value) ? 'select' : 'deselect'](event);
                // only one click per page load, so squash observers
                b.stopObserver('buttonClick');
                b.stopObserver('buttonMouseOver');
                b.stopObserver('buttonMouseOut');
                this.stopObserver('valueSliderMouseOut');
            }
        }
        // do other stuff on selection
        if (this.onselect) this.onselect(event, button);
    },

    mouseOver: function (event, button) {
        var index = button.getIndex();
        for (var i = 0, length = this.buttons.length; i < length; i++) {
            var b = this.buttons[i];
            // over
            if (i <= index) {
                b.element.removeClassName('half');
                b.element.addClassName('mouseover');
            // out
            } else {
                b.element.removeClassName('half');
                b.element.removeClassName('mouseover');
            }
        }
    },
    
    mouseOut: function (event) {
        for (var i = 0, length = this.buttons.length; i < length; i++) {
            var b    = this.buttons[i];
            var diff = this.value - i;
            // out
            if (diff <= 0.25) {
                b.element.removeClassName('half');
                b.element.removeClassName('mouseover');
            // half over
            } else if (diff <= 0.75) {
                b.element.addClassName('half');
                b.element.removeClassName('mouseover');
            // full over
            } else {
                b.element.removeClassName('half');
                b.element.addClassName('mouseover');
            }
        }
    }
});


ValueSlider.Button = Class.create(Button, {
        name:  'ValueSliderButton',

        initialize: function ($super, slider) {
            // setup
            $super(document.createElement('li'));
            // set owner
            this.slider = slider;
            this.slider.ul.insert(this.element);
            this.index = this.slider._index++;
        },

        getIndex: function () {
            return this.index;
        },

        click: function (event) {
            this.slider.select(event, this);
        },

        mouseOver: function (event) {
            this.slider.mouseOver(event, this);
        }
});
     