Array.prototype.some ?= (f) ->
  (return true if f x) for x in @
  return false

Array.prototype.every ?= (f) ->
  (return false if not f x) for x in @
  return true

$ ->
  $('#search').on 'keyup', (event) ->
    query = event.currentTarget.value.toLowerCase().split(' ')
    # console.log(query)
    if query.every( (x) -> x == "")
      # console.log('no query')
      $('figure').removeClass('hidden')
    else
      $('figure').each (index, fig) ->
        $fig = $(fig)
        names = $fig.attr('data-name').toLowerCase().split(' ')
        matching = query.every (q) ->
          names.some (name) ->
            name.search(q) > -1

        if matching
          $fig.removeClass('hidden')
        else
          $fig.addClass('hidden')

    lazy_load()


# Toggle icon sets
$ ->
  $('input.set').on 'change', (event) ->
    console.log(event)
    checkbox = $(event.currentTarget)
    name = checkbox.attr('value')
    checked = checkbox.is(':checked')
    console.log(checkbox, name, checked)
    section = $("section[data-name='" + name + "']")
    if checked
      section.removeClass('hidden')
    else
      section.addClass('hidden')
    lazy_load()

# Lazy loading
$ ->
  $window = $(window)
  scheduled = false

  margin = 300

  in_viewport = (element) ->
    $element = $(element)

    window_top = $window.scrollTop() - margin
    window_bottom = $window.height() + margin

    offset = $element.offset()
    top = offset.top
    bottom = top + $element.height()

    return (bottom > 0 && top < window_bottom)

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
      if in_viewport(element)
        load_img(element)

  # window.mark_visible = () ->
  #   $("img[data-src]").each (i, element) ->
  #     $(element).toggleClass('mark', in_viewport(element))

  schedule_lazy_load = () ->
    if scheduled == false
      scheduled = true
      setTimeout ( ->
        lazy_load()
        scheduled = false
      ), 500

  $(document).on 'scroll', (event) ->
    schedule_lazy_load()
  $(document).on 'resize', (event) ->
    schedule_lazy_load()
  lazy_load()
