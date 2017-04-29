class Application.Classes.Alert
  defaults:
    type:   "success"
    delay:  6000
    z_index: 1100

  constructor: (@$el) ->
    super

  @danger: (msg, options = {}) ->
    options.type = "danger"
    @notifyMessage(msg, options)

  @success: (msg, options = {}) ->
    options.type = "success"
    @notifyMessage(msg, options)

  @info: (msg, options = {}) ->
    options.type = "info"
    @notifyMessage(msg, options)

  @notifyMessage: (msg, options = {}) ->
    finalOptions = $.extend(Application.Classes.Alert::defaults, options)

    $.notify({
                title:   finalOptions.title,
                message: msg,
                url:     finalOptions.url,
                target:  finalOptions.target
              },
              {
                type:     finalOptions.type,
                delay:    finalOptions.delay
#                template: finalOptions.template
            })