Array.prototype.some ?= (f) ->
  (return true if f x) for x in @
  return false

Array.prototype.every ?= (f) ->
  (return false if not f x) for x in @
  return true

# Search
$ ->
  $('#search').on 'keyup', (event) ->
    query = event.currentTarget.value.toLowerCase().split(' ')
    query.filter (term, i) ->
      term.length == 0
    if query.every( (x) -> x == "")
      css = ''
    else
      selectors = query.map (item, i) ->
        '.icons figure:not([data-name*="' + item.replace(/\"/g, '\\\"') + '"])'
      css = selectors.join(', ') + '{ display: none; }'
    console.log(css)
    $('#searchStyle').text(css)
    lazy_load()


# Toggle icon sets
$ ->
  $('input.set').on 'change', (event) ->
    checkbox = $(event.currentTarget)
    name = checkbox.attr('value')
    checked = checkbox.is(':checked')
    section = $("section[data-name='" + name + "']")
    if checked
      section.removeClass('hidden')
    else
      section.addClass('hidden')
    lazy_load()


# Lazy loading
inViewport = (element) ->
  if typeof jQuery == "function" && element instanceof jQuery
    element = element[0];

  rect = element.getBoundingClientRect();

  return (
    rect.top >= 0 &&
    rect.left >= 0 &&
    rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) && # or $(window).height()
    rect.right <= (window.innerWidth || document.documentElement.clientWidth) # or $(window).width()
    )

$ ->
  $window = $(window)
  scheduled = false

  margin = 300

  load_img = (element) ->
    $element = $(element)
    return if $element.attr('src')
    $element.attr('src', $element.attr('data-src'))
    # $element.removeAttr('data-src')

  $('img').on 'load', (event) ->
    $element = $(event.currentTarget)
    $element.removeAttr('data-src')

  window.lazy_load = () ->
    $("img[data-src]").each (i, element) ->
      if inViewport(element)
        load_img(element)

  # window.mark_visible = () ->
  #   $("img[data-src]").each (i, element) ->
  #     $(element).toggleClass('mark', inViewport(element))

  schedule_lazy_load = () ->
    if scheduled == false
      scheduled = true
      setTimeout ( ->
        lazy_load()
        scheduled = false
      ), 500

  $(window).on 'scroll resize', (event) ->
    schedule_lazy_load()

  lazy_load()

  $('body').append('<style id="searchStyle"/>')
