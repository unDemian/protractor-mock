module.exports = () ->
  init = angular.module("httpBackendMockInit", [])

  init.service 'Mock', () ->

    # Endpoint Configuration
    ################################################################
    @games =
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

    @consoles =
      url: '/consoles'
      response:
        data: {
          "1": "Xbox One",
          "2": "PS4",
        }

    ################################################################
    # You shall NOT edit, anymore!
    ################################################################

    # Properties
    @resources  = []
    @element    = 'element'
    @array      = 'array'
    @object     = 'object'

    # Methods
    @init = () ->
      @resources  = []

    @endpoint = (endpoint, options) ->
      resource = {}
      resource.endpoint = endpoint
      resource.options = options
      @resources.push resource

    return

  init.run ['Mock', (Mock) ->
    Mock.init()
  ]
return