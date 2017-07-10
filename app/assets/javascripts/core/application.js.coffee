window.Application         ||= {}
window.Application.Classes ||= {}

class Application.Core

  start: ->
    NProgress.configure({'showSpinner': false})

    $(document).on 'turbolinks:load', =>
      @initializeAllPlugins()
      @bindClasses()

      @disableNumericValueScroll()

  initializeAllPlugins: =>
    @initializeSelect2()

  bindClasses: ($parent = $('body')) =>
    $parent.find("[data-class-binder]").each (k, el) =>
      for index, className of $(el).data("classBinder").split(" ")
        unless $(el).hasClass(className)
          new Application.Classes[className]($(el))
          $(el).addClass(className)

  initializeSelect2: ->
    #todo via data attr?
    if location.pathname.includes?('players')
      $('.select2').select2(width: '60%')
    else
      $('.select2').select2(
  #      height: '60'
        width: '170'
  #      containerCssClass: ':all:'
        minimumResultsForSearch: Infinity
      )

  disableNumericValueScroll: ->
    $(':input[type=number]').on 'mousewheel', (e) ->
      $(this).blur()
