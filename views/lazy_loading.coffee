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

loadImage = (element) ->
  $element = $(element)
  return if $element.attr('src')
  $element.attr('src', $element.attr('data-src')).removeAttr('data-src')

window.lazyLoad = () ->
  loadImage(img) for img in ($("img[data-src]").dom) when inViewport(img)

scheduled = false
window.scheduleLazyLoad = () ->
  if scheduled == false
    scheduled = true
    setTimeout ( ->
      lazyLoad()
      scheduled = false
    ), 800

$(window).on 'scroll resize', (event) ->
  scheduleLazyLoad()

$ ->
  scheduleLazyLoad()
