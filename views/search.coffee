Array.prototype.some ?= (f) ->
  (return true if f x) for x in @
  return false

Array.prototype.every ?= (f) ->
  (return false if not f x) for x in @
  return true


$ ->
  $style = $('<style id="searchStyle"/>').appendTo('body')

  # Search
  $('#search').on 'keyup', (event) ->
    query = event.currentTarget.value.toLowerCase().replace(/\'/g, '\\\'').split(' ')
    selectors = ("figure:not([data-name*='#{term}'])" for term in query when term.length )
    css = if selectors.length then selectors.join(', ') + '{ display: none; }' else ""
    $style.text(css)
    scheduleLazyLoad()

  # Toggle icon sets
  $('input.set').on 'change', (event) ->
    $checkbox = $(event.currentTarget)
    name = $checkbox.attr('value')
    checked = $checkbox.is(':checked')
    $("section[data-name='" + name + "']").toggleClass('hidden', !checked)
    scheduleLazyLoad()

  $('button#delesect').on 'click', (event) ->
    $form = $(event.currentTarget).closest('form')
    $form.find('input.set').prop('checked', false)
