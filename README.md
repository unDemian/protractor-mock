## Protractor Mock Service 

`protractor-mock` creates a more flexible interface for mocking **$httpBackend** requests in [Protractor](https://github.com/angular/protractor).

Basically, it allows you to keep all your mocking data structured in distinct files for each endpoint and never again copy/paste json data in your `spec` files. Also you can easily handle multiple endpoints or requests and custom response scenarios.

## Installation

###### Requirements
* [CoffeScript](https://www.npmjs.org/package/coffee-script)
* [AngularJs](https://github.com/angular/angular.js)
* [Angular Mocks](https://github.com/angular/angular.js/tree/master/src/ngMock) (ngMockE2E)
* [Protractor](https://github.com/angular/protractor)


###### Installation
1. clone this [repo](https://github.com/unDemian/protractor-mock.git) or download the [zip archive](https://github.com/unDemian/protractor-mock/archive/master.zip)
2. copy the `mock/` folder into your **e2e** folder
3. Done `:]`


## Configuration

First include the module in your `spec` files 
```coffeescript
mockModule  = require './mock/http.coffee'
```

###### Mocking Data

Data files are angular modules that have mock data and responses for your endpoints.
You can create a data file for each endpoint or group of related endpoints. I suggest you keep all your data files in
the `mock/data/` folder. Example data file [/mock/data/example.data.coffee](https://github.com/unDemian/protractor-mock/blob/master/mock/data/example.data.coffee)

###### Create a data file
* Create your `.data.coffee` file in the `mock/data/` folder
* Use the pattern from the example file
* Use a unique name for your angular module ( angular.module("**MockedGames**", []) )
* Mock your endpoints using `Mock.add(name, options)`

  `name` - The name of the endpoint (you will reference this later as `Mock.name` so be careful)
  `options` - Object containing configuration data and response types
  
  | Option     | Type       | Description   | Required  |
  | ---------- | ---------- | ------------- | --------- |
  | `url` | **string** | url of your endpoint, use the root endpoint because you can concatenate data later to it  | Yes |
  | `response` | **object** | configuration for all possible responses of this endpoint | Yes |
  | `response.data` | **object** | mocked json data | Yes |
  | `response.xxx` | **object** | You can attach custom response messages to be referenced later as `Mock.name.response.xxx` | - |

* Include your data file in the `http.coffee` 
  ```coffeescript
  games = require './data/example.data.coffee'
  ```

* Add it to the exports of the `http.coffee` module
  ```coffeescript
  module.exports.mockedGames = games
  ```

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
- `type` - is it a list or an element endpoint (`/games` vs `/console`)
- `get` / `post` / `put` / `delete` - here you can overwrite the default behaviour for each method of that endpoint.
    - status - represents the expected response status ( `success` / `error` )
    - message - represents the expected response message ( for `GET` (element) / `PUT` / `POST` ) you don't need any message because the element will be the response

#### Inject your application as a dependency
    httpBackendMock = () ->
        angular.module("httpBackendMock", ["app", "ngMockE2E"]).run ['$httpBackend', 'Mock', ($httpBackend, Mock) ->

Use mocked data in your tests
----
**NOTE**: Before each test, clean the loaded mock modules and run the `httpBackendMockInit`

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


# API Docs

# Directory Layout

- `mock/init.coffee`
- `mock/http.coffee`

# Contact
For more information on `protractor-mock` hit me up  [@unDemian](https://twitter.com/unDemian)
