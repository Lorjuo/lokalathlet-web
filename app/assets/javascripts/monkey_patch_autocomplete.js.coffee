$ ->
  # Don 't really need to save the old fn, 
  # but I could chain if I wanted to
  oldFn = $.ui.autocomplete::_renderItem
  $.ui.autocomplete::_renderItem = (ul, item) ->
    #re = new RegExp("^" + @term, "i")
    re = new RegExp(@term, "i")
    t = item.label.replace(re,"<span style='font-weight:bold;color:#0000A0;'>" +  "$&" +  "</span>");
    $("<li></li>").data("item.autocomplete", item).append("<a>" + t + "</a>").appendTo ul

    #http://stackoverflow.com/questions/2435964/jqueryui-how-can-i-custom-format-the-autocomplete-plug-in-results
    #https://github.com/crowdint/rails3-jquery-autocomplete/issues/144