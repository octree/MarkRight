'use strict';
window.cssInjector = {
    
    inject: function inject(json) {
        let identifier = json["identifier"]
        let css = json["css"]
        var style = document.getElementById(identifier);
        if (!style) {
          var style = document.createElement('style');
          style.type = 'text/css';style.setAttribute('id', identifier);
        }
        style.innerHTML = css;
        document.getElementsByTagName('head')[0].appendChild(style);
    },
    
    remove: function remove(identifier) {
        
        var style = document.getElementById(identifier);
        if (style) {
            style.parentNode.removeChild(style);
        }
    }
};
