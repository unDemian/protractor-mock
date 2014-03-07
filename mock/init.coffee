module.exports = () ->
  init = angular.module("httpBackendMockInit", [])

  init.service 'Mock', () ->

    # Properties
    @resources  = []
    @element    = 'element'
    @array      = 'array'
    @object     = 'object'

    # 'Constructor' this method is called when the module is running
    @init = () ->
      @resources  = []

    # Add an endpoint to service
    @add: (name, value) ->
      Object.defineProperty @::, name, value: value

    # Configurate an endpoint behaviours
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