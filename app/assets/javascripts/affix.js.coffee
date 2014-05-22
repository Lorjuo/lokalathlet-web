$ ->
  $affixElement = $("div[data-spy=\"affix\"]")
  $affixElement.width $affixElement.parent().width()
  #$("div[data-spy=\"affix\"]").width($('#afficSpacer').width());
#http://jsfiddle.net/2JGQa/
#http://stackoverflow.com/questions/18683303/bootstrap-3-0-affix-with-list-changes-width
# $(".affix").affix
#   offset:
#     top: 100
    # bottom: ->
    #   @bottom = $(".footer").outerHeight(true)
