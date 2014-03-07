Requirements
========
- Protractor
- Angular mocks

Structure
========

- `mock/init.coffee` -
- `mock/http.coffee` -

Important
========

**The mock configuration loading or updating have to be the first operations of your test**

Mock Configuration
==================================
First include the services mock into your `scenarios.spec.coffe` file

    mockModule = require "./mock.coffee"
    
The services mock has 3 main modules

- `httpBackendMockInit` - this is used to set default values before each test
- `httpBackendMockUpdate` - this is used to update the default values with your test specific data
- `httpBackendMock` - this is used to bind your mocking rules to the $httpBackend service

Configurate Mock data and default behaviour
----
Take a look at the `mock.coffee` file, play with variables only if you see a *Configuration* word in the comments.

#### Endpoint Configuration
For each endpoint you have the following configuration options
- url - the url of the endpoint
- response - copy / paste the json returned on the endpoint (list of elements)
  - data - copy / paste the json returned on the endpoint (list of elements)
  - success - messages for success
  - error - messages for error

    @games:
      url: '/games'
      data: {
        "3": "Xbox",
        "4": "PS4",
      }
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


#### Mocked Resources Configuration
The `init()` method is called before each test when loading the `httpBackendMockInit`, here you can configure the default behaviour of your mocking module.

    Mock.endpoint(Mock.games, [
        {
          get:
            passThrough: true
        }
        {
          get:
            arguments: '/2'
            response: Mock.games.response.error.notFound
        }
        {
          get:
            arguments: '/1'
            type: Mock.element
        }
        {
          get:
            arguments: '/list'
            type: Mock.array
            response:
              headers: [ 'X-Type: 400' ]
        }
        {
          get:
            arguments: '/filter'
            response:
              code: 200
              content: 'weqweq'
          delete:
            response: Mock.games.response.success.delete
        }
      ]

    @init = ()->
      @resource = [

      ]

`resource` is the default array of resource behaviours (object). This can be updated using the `config(resource)` . 

Basically each object in this resource represents a set of that will apply to mock the `$http` service.
- `endpoint` - here you can set which endpoint is affected
- `type` - is it a list or an element endpoint (`/mx-admin/v1/api/admin/discovery` vs `/mx-admin/v1/api/admin/discovery/400`)
- `get` / `post` / `put` / `delete` - here you can overwrite the default behaviour for each method of that endpoint.
    - status - represents the expected response status ( `success` / `error` )
    - message - represents the expected response message ( for `GET` (element) / `PUT` / `POST` ) you don't need any message because the element will be the response

#### Inject your application as a dependency
    httpBackendMock = () ->
        angular.module("httpBackendMock", ["app", "ngMockE2E"]).run ['$httpBackend', 'Mock', ($httpBackend, Mock) ->

Use mocked data in your tests
----
*** NOTE ***: Before each test, clean the loaded mock modules and run the `httpBackendMockInit`

    beforeEach ->
        ptor = protractor.getInstance()
        
        # Clean loaded modules
        ptor.clearMockModules()
        
        # Add the default mocking data
        ptor.addMockModule 'httpBackendMockInit', servicesMock.httpBackendMockInit 

Here is an example if you want to use the default mock configurations for your test (the ones that you've set in the `init()` method)

    describe "Actions ->", ->
        it "should take you to the edit page", ->

            # Mock $http service with default configurations
            ptor.addMockModule 'httpBackendMock', servicesMock.httpBackendMock

            ptor.get ptor.baseUrl + '/games'

If you want to alter the the mocking configuration, just update it and then load the `httpBackendMock` 

  
With this script we train the mock module return a date mismatch error `Mock.messages.errors.dateMismatch` if we have a *GET* request for an *element* ( `Mock.element` ) with the id (1) using the *endpoint* `Mock.endpoints.entity`  

### Examples
Example with two different methods on the same endpoint


    
Example for two different endpoints


