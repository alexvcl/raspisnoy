class Application.Classes.FormScores

  constructor: (@$scope = $('body')) ->
    @$scope.find('label.checkbox').each (index, label) =>
      $(label).css('font-size', '18px')

    @$scope.find("[name='round[jokers][]']").on 'click', (event) =>
      if @$scope.find("[type='checkbox']:checked:enabled").length == 2
        @$scope.find("[type='checkbox']").not(":checked:enabled").attr('disabled', 'disabled')
      else if @$scope.find("[type='checkbox']:checked:enabled").length < 2
        @$scope.find("[type='checkbox']").not(":checked:enabled").attr('disabled', false)

