// jQuery Plugin Boilerplate
// A boilerplate for jumpstarting jQuery plugins development
// version 2.0, July 8th, 2011
// by Stefan Gabos

// remember to change every instance of "pluginName" to the name of your plugin!
// the semicolon at the beginning is there on purpose in order to protect the integrity 
// of your scripts when mixed with incomplete objects, arrays, etc.
;
(function($) {

    // we need attach the plugin to jQuery's namespace or otherwise it would not be
    // available outside this function's scope
    // "el" should be a jQuery object or a collection of jQuery objects as returned by
    // jQuery's selector engine
    $.suggestionBox = function(el, options) {

        // plugin's default options
        // this is private property and is accessible only from inside the plugin
        var defaults = {

            propertyName: 'value',
            serviceUrl: '/athlets/suggestions/',
            observableSelector: '.athlet',
            markup: "<div class='athletSuggestion' data-athlet-id='{%=o.id%}'>" +
                "<div class='name'>{%=o.firstname%} {%=o.surname%}</div>" +
                "<div class='sex'>{%=o.sex%}</div>" +
                "<div class='birthday'>{%=o.birthday%}</div>" +
            "<div class='club'>{%=o.club%}</div>" +
                "<div class='events'>{%=o.events%}</div>" +
                "</div>",

            // if your plugin is event-driven, you may provide callback capabilities 
            // for its events. call these functions before or after events of your 
            // plugin, so that users may "hook" custom functions to those particular 
            // events without altering the plugin's code
            onSomeEvent: function() {}

        }

        // to avoid confusions, use "plugin" to reference the
        // current instance of the  object
        var plugin = this;

        // this will hold the merged default, and user-provided options
        // plugin's properties will be accessible like:
        // plugin.settings.propertyName from inside the plugin or
        // myplugin.settings.propertyName from outside the plugin
        // where "myplugin" is an instance of the plugin
        plugin.settings = {}

        // private
        var observables = [];
        var focus = null;
        plugin.athlets = {};

        // the "constructor" method that gets called when the object is created
        // this is a private method, it can be called only from inside the plugin
        var init = function() {

            // the plugin's final properties are the merged default and 
            // user-provided options (if any)
            plugin.settings = $.extend({}, defaults, options);

            // make the collection of target elements available throughout the plugin
            // by making it a public property
            plugin.el = el;

            // code goes here
            plugin.template = tmpl(plugin.settings.markup);
            //plugin.el.text('ALALABAMBA');
            // plugin.observables = $(plugin.settings.observables)
            // plugin.observables.focus(function() {
            //     alert("Handler for .focus() called.");
            //     plugin.changeFocus(this);
            // });
            $(".athlet").each(function(index) {
                //console.log( index + ": " + $( this ).text() );
                observable = new Observable($(this), plugin);
                observables.push(observable);
            });

            $(window).bind('keydown', function(e) {
                //if (e.ctrlKey && e.keyCode == 13) {
                // Ctrl-Enter pressed
                //if (e.ctrlKey && e.keyCode == 32) {
                // Ctrl-Spae pressed
                if (e.ctrlKey && e.altKey) {
                    // Ctrl-Alt pressed
                    plugin.takeValues(0);
                }
            })
        }

        // public methods
        // these methods can be called like:
        // plugin.methodName(arg1, arg2, ... argn) from inside the plugin or
        // myplugin.publicMethod(arg1, arg2, ... argn) from outside the plugin
        // where "myplugin" is an instance of the plugin

        // a public method. for demonstration purposes only - remove it!
        plugin.foo_public_method = function() {

            // code goes here

        }

        plugin.changeFocus = function(observable) {
            if (focus != observable) {
                if (focus != null) focus.blur();
                focus = observable;
                focus.focus();
            }

            //plugin.el.text(observable.id);
            //plugin.el.text(JSON.stringify(observable.getValues()));
            plugin.searchAthlets(observable.getValues());
        }

        plugin.updateParams = function(observable) {
            if (focus != observable) {
                if (focus != null) focus.blur();
                focus = observable;
                focus.focus();
            }
            //plugin.el.text(observable.id);
            //plugin.el.text(JSON.stringify(observable.getValues()));
            plugin.searchAthlets(observable.getValues());
        }

        plugin.searchAthlets = function(params) {
            $.getJSON(plugin.settings.serviceUrl, params,
                function(data) {
                    //plugin.el.text(JSON.stringify(data));
                    plugin.updateSuggestions(data["athlets"])
                }
            );
        }

        plugin.updateSuggestions = function(athlets) {
            // for (i in athlets) {
            //     athletCode = plugin.template(athlets[i]);
            //     $(athletCode).hide().appendTo(plugin.el).fadeIn(1000);
            // }
            for (i in plugin.athlets) {
                if (!(i in athlets)) {
                    $('*[data-athlet-id="' + plugin.athlets[i].id + '"]').fadeOut(300, function() {
                        $(this).remove();
                    });
                }
            }
            for (i in athlets) {
                if (!(i in plugin.athlets)) {
                    athletCode = plugin.template(athlets[i]);
                    athletElement = $(athletCode);
                    athletElement.click(function() {
                        plugin.takeValues($(this).data('athlet-id'))
                    })
                    athletElement.delay(300).hide().appendTo(plugin.el).fadeIn(300);
                }
            }
            plugin.athlets = athlets;
        }

        plugin.takeValues = function(athletId) {
            if (athletId == 0) {
                // http://stackoverflow.com/questions/909003/javascript-getting-the-first-index-of-an-object
                for (first in plugin.athlets) break;
                athletId = first;
            }
            focus.setValues(plugin.athlets[athletId]);
        }

        // private methods
        // these methods can be called only from inside the plugin like:
        // methodName(arg1, arg2, ... argn)

        // a private method. for demonstration purposes only - remove it!
        var foo_private_method = function() {

            // code goes here

        }

        // call the "constructor" method
        init();

    }

})(jQuery);

$(document).ready(function() {

    // create a new instance of the plugin
    var myplugin = new $.suggestionBox($('#suggestionBox'));

    // call a public method
    myplugin.foo_public_method();

    // get the value of a public property
    myplugin.settings.property;

});

function Observable(el, observer) {
    var observable = this;

    var timer;
    var delay = 350; // 0.3 seconds delay after last input

    this.init = function() {
        el.bind("click", function() {
            observer.changeFocus(observable)
        });
        el.find(".firstname").bind("change paste keyup", function() {
            // observer.updateParams(observable)
            // http://www.webdevdoor.com/jquery/javascript-delay-input-field-change/
            window.clearTimeout(timer);
            timer = window.setTimeout(function() {
                //insert delayed input change action/event here
                observer.updateParams(observable)
            }, delay);
        });
        el.find(".surname").bind("change paste keyup", function() {
            // observer.updateParams(observable)
            // http://www.webdevdoor.com/jquery/javascript-delay-input-field-change/
            window.clearTimeout(timer);
            timer = window.setTimeout(function() {
                //insert delayed input change action/event here
                observer.updateParams(observable)
            }, delay);
        });
    }

    this.getValues = function() {
        return {
            firstname: el.find(".firstname").val(),
            surname: el.find(".surname").val(),
            sex: el.find(".sex").find(":selected").text(),
            birthday: el.find(".birthday").val()
        };
    }

    this.setValues = function(athlet) {
        el.find(".firstname").val(athlet['firstname']);
        el.find(".surname").val(athlet['surname']);
        el.find(".sex").val(athlet['sex']);
        el.find(".birthday").val(athlet['birthday']);
        el.find(".club").val(athlet['club']);
        el.switchClass(null, "blink", 500, "easeInOutQuad")
            .switchClass("blink", null, 500, "easeInOutQuad");
    }

    this.create_message = function(message) {
        el.html(message);
    };

    this.focus = function() {
        //el.addClass('focus');
        el.switchClass("inactive", "active", 500, "easeInOutQuad");
    }
    this.blur = function() {
        //el.removeClass('focus');
        el.switchClass("active", "inactive", 500, "easeInOutQuad");
    }

    this.init();
}