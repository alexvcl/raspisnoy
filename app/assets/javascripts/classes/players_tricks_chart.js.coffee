class Application.Classes.PlayersTricksChart

  constructor: (@$scope = $('body')) ->
    Chart.defaults.global["layout"] = {padding: {left: 15, top: 20, right: 0, bottom: 0}}

    ctx = document.getElementById('myChart')
    console.log ctx

    myChart = new Chart(ctx,
#      type: 'bar'
      type: 'horizontalBar'
      data:
        labels: @$scope.data('player-names')
        datasets: [ {
          label: '# of successful tricks'
          data: @$scope.data('player-scores')
          backgroundColor: [
            '#0d5e92'
            '#aad7f4'
            '#1aae88'
            '#1ccacc'
            'rgba(153, 102, 255, 1)'
            'rgba(255, 99, 132, 1)'
          ]
          borderColor: [
            '#0d5e92'
            '#aad7f4'
            '#1aae88'
            '#1ccacc'
            'rgba(153, 102, 255, 1)'
            'rgba(255,99,132,1)'
          ]
          borderWidth: 1
        } ]
      options: {legend: {display: false}, scales: xAxes: [ { ticks: {stepSize: 1, beginAtZero: true}  } ]} )
