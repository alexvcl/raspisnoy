window.Raspisnoy         ||= {}
window.Raspisnoy.Classes ||= {}

class Raspisnoy.Application

  start: ->
#    NProgress.configure({'showSpinner': false})

    $(document).on 'turbolinks:load', =>
      @initializeAllPlugins()
      @bindClasses()

  initializeAllPlugins: =>
    @initializeSelect2()

  bindClasses: ($parent = $('body')) =>
    $parent.find("[data-class-binder]").each (k, el) =>
      for index, className of $(el).data("classBinder").split(" ")
        unless $(el).hasClass(className)
          new StaplePulse.Classes[className]($(el))
          $(el).addClass(className)

  initializeSelect2: ->
    $('.select2').select2()
