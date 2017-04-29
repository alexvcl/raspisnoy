class Application.Classes.GrowlFlash

  constructor: (@$scope = $('body')) ->
    messages = @$scope.data('messages')
    console.log messages

    for k, v of messages
      message = ''

      if v.message instanceof Array
        message = v.message[0].join('; ')
      else
        message

      Application.Classes.Alert.notifyMessage(message, {type: v.type})
