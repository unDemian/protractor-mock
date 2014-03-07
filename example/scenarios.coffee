'use strict'

mockModule  = require './../mock/http.coffee'

describe 'Mocking Test ->', ->

  ptor = undefined

  beforeEach ->
    ptor = protractor.getInstance()

    # Clear loaded mock modules & Initialize http mock module
    ptor.clearMockModules()
    ptor.addMockModule 'httpBackendMockInit', mockModule.httpBackendMockInit
    ptor.addMockModule 'MockedGames', mockModule.mockedGames

  it 'should throw error', ->

    # Update behaviour for mocked endpoints
    ptor.addMockModule 'httpBackendMockUpdate', () ->
      angular.module('httpBackendMockUpdate', []).run ['Mock', (Mock) ->
        Mock.endpoint(Mock.games, [
          {
            get:
              arguments: '/all'
              response: Mock.entity.response.error.notFound
          }
        ])
        Mock.endpoint(Mock.consoles, [
          {
            get:
              type: Mock.object
          }
        ])
      ]

    # Apply your mock module for http
    ptor.addMockModule 'httpBackendMock', mockModule.httpBackendMock

    ptor.get ptor.baseUrl