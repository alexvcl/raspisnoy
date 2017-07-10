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
    @initializeLazyModal()
    @initializeBootstrapFileStyle()

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

  initializeLazyModal: ->
    $("[data-lazy-modal]").off('click').on 'click', (event) =>
      show_mode = $(event.currentTarget).data('lazy-modal-readonly')

      window.lazyModal = BootstrapDialog.show
        title: $(event.currentTarget).data('lazy-modal-title')
        type: $(event.currentTarget).data('lazy-modal-type') || BootstrapDialog.TYPE_PRIMARY
        message: $('<div class="text-center"><img src="/spinner.gif" class = "modal-spinner"></div>')
        buttons: [
          {
            id: 'lazy-modal-submit'
            icon: "glyphicon glyphicon-floppy-disk"
            autospin: true
            label: 'Save'
            cssClass: ($(event.currentTarget).data('lazy-modal-type') || BootstrapDialog.TYPE_PRIMARY).replace('type', 'btn')
            action: (dialogRef) ->
              dialogRef.getModalBody().find('form').submit()
              dialogRef.enableButtons(false)
              dialogRef.setClosable(false)
          },
          {
            label: 'Cancel'
            action: (dialogRef) ->
              dialogRef.close()
          }
        ] unless show_mode # we don't need buttons in 'show' mode

        onshow: (dialog) =>
          dialog.setClosable(true)
          unless show_mode # we don't need footer in 'show' mode
            dialog.enableButtons(true)
            dialog.getModalFooter().find(".icon-spin").remove()
            dialog.getModalFooter().find(".glyphicon-floppy-disk").css("display", "")

        onshown: (dialog) =>
          dialog.getModalBody().load $(event.currentTarget).attr('href'), =>
            @initializeAllPlugins()
            @bindClasses()

  initializeBootstrapFileStyle: ->
    $files = $(":file")
    $files.filestyle('icon', false)
    $files.filestyle('buttonText', 'Choose file')
#    $files.css("left", -500)
    fileContaineer = $(".bootstrap-filestyle")
    fileContaineer.children("input:last").attr('id', "file_attachment_#{(new Date).valueOf()}")
    fileContaineer.children("label:last").attr('id', "file_attachment_#{(new Date).valueOf()}")

    $(".bootstrap-filestyle").find('label').css('margin-right', 130)
#    fileContaineer.children("input").addClass("form-control inline v-middle input-s")
#    fileContaineer.children("label").addClass("btn-default")
