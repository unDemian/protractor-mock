init  = require './init.coffee'
games = require './data/example.data.coffee'

mock = () ->

  # Add your app module as a dependency
  angular.module("httpBackendMock", ["app-name", "ngMockE2E"]).run ['$httpBackend', 'Mock', ($httpBackend, Mock) ->

    angular.forEach Mock.resources, (resource) ->
      endpoint = resource.endpoint
      angular.forEach resource.options, (options) ->
        angular.forEach options, (option, method) ->

          # URL
          url = endpoint.url
          if option.hasOwnProperty 'arguments'
            url += option.arguments

          # Method
          method = method.toUpperCase()

          # Response
          code = undefined
          content = undefined
          headers = undefined

          if option.hasOwnProperty 'response'
            response = option.response
            if response.hasOwnProperty 'code'
              code = response.code
            else
              code = 200

            if response.hasOwnProperty 'headers'
              headers = response.headers

            if response.hasOwnProperty 'content'
              content = response.content
            else
              if option.hasOwnProperty 'type'
                if option.type is Mock.element
                  content = endpoint.response.data[0]
                else
                  content = endpoint.response.data
              else
                content = endpoint.response.data
          else
            code = 200
            if option.hasOwnProperty 'type'
              if option.type is Mock.element
                content = endpoint.response.data[0]
              else
                content = endpoint.response.data
            else
              content = endpoint.response.data

          # Request
          request = $httpBackend.when(method, url)

          if option.hasOwnProperty 'passThrough'
            request.passThrough()
          else
            request.respond code, content, headers
  ]

module.exports.httpBackendMockInit = init
module.exports.httpBackendMock     = mock

# Data exports
module.exports.mockedGames         = games