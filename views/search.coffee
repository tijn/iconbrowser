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


  # Toggle icon sets

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
