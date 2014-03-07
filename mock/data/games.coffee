module.exports = () ->
  angular.module("MockedGames", []).run ['Mock', (Mock) ->

    # Endpoint Configuration
    ################################################################
    Mock.add 'games',
      url: '/games'
      response:
        data: [
          {
            "name": "Starcraft II",
            "level": 30
          },
          {
            "name": "FIFA 2014",
            "level": 15
          },
          {
            "name": "DOTA 2",
            "level": 5
          },
        ]

      # Custom messages
        success:
          deleted:
            code: 200
            content: 'Delete Successful'
            headers: []

        error:
          notFound:
            code: 404,
            content: 'Not found'
            headers: []

    Mock.add 'consoles',
      url: '/consoles'
      response:
        data: {
          "1": "Xbox One",
          "2": "PS4",
        }

  ]
return