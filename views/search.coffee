Array.prototype.some ?= (f) ->
  (return true if f x) for x in @
  return false

Array.prototype.every ?= (f) ->
  (return false if not f x) for x in @
  return true


$ ->
  # Search
  $('#search').on 'keyup', (event) ->
    query = event.currentTarget.value.toLowerCase().replace(/\'/g, '\\\'').split(' ')
    selectors = ("figure:not([data-name*='#{term}'])" for term in query when term.length )
    css = if selectors.length then selectors.join(', ') + '{ display: none; }' else ""
    $('#searchStyle').text(css)
    scheduleLazyLoad()


  # Toggle icon sets
  $('input.set').on 'change', (event) ->
    $checkbox = $(event.currentTarget)
    name = $checkbox.attr('value')
    checked = $checkbox.is(':checked')
    $("section[data-name='" + name + "']").toggleClass('hidden', !checked)
    scheduleLazyLoad()


# Lazy loading
inViewport = (element) ->
  if typeof jQuery == "function" && element instanceof jQuery
    element = element[0];

  rect = element.getBoundingClientRect();

  return (
    rect.top >= 0 &&
    rect.left >= 0 &&
    rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) && # or $(window).height() ??
    rect.right <= (window.innerWidth || document.documentElement.clientWidth) # or $(window).width() ??
    )

$ ->
  $window = $(window)
  scheduled = false

  margin = 300

  loadImage = (element) ->
    $element = $(element)
    return if $element.attr('src')
    $element.attr('src', $element.attr('data-src'))
    # $element.removeAttr('data-src')

  $('img').on 'load', (event) ->
    $element = $(event.currentTarget)
    $element.removeAttr('data-src')

  window.lazyLoad = () ->
    $("img[data-src]").each (i, element) ->
      loadImage(element) if inViewport(element)

  # window.mark_visible = () ->
  #   $("img[data-src]").each (i, element) ->
  #     $(element).toggleClass('mark', inViewport(element))

  window.scheduleLazyLoad = () ->
    if scheduled == false
      scheduled = true
      setTimeout ( ->
        lazyLoad()
        scheduled = false
      ), 800

  $(window).on 'scroll resize', (event) ->
    scheduleLazyLoad()

  scheduleLazyLoad()

  $('body').append('<style id="searchStyle"/>')
