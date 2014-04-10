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

###### Create a data file

Data files are angular modules that have mock data and responses for your endpoints.
You can create a data file for each endpoint or group of related endpoints. I suggest you keep all your data files in
the `mock/data/` folder. Example data file [/mock/data/example.data.coffee](https://github.com/unDemian/protractor-mock/blob/master/mock/data/example.data.coffee)

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

###### Configurate your `http.coffee`
Include your data file in the `http.coffee` 
```coffeescript
  games = require './data/example.data.coffee'
```

Add it to the exports of the `http.coffee` module
```coffeescript
  module.exports.mockedGames = games
```

Replace `app-name` with your main app module in `http.coffee`
```coffeescript
  angular.module("httpBackendMock", ["app-name", "ngMockE2E"]).run ['$httpBackend', 'Mock', ($httpBackend, Mock) ->
```

Usage
----

Include the mock module into your `spec` files
```coffeescript
  mockModule  = require './mock/http.coffee'
```

Add required mock modules in your `beforeEach` statement, beside the initialization module you can add as many data modules as you need 
```coffeescript
  ptor.clearMockModules() # Clear loaded mock modules
  ptor.addMockModule 'httpBackendMockInit', mockModule.httpBackendMockInit # Initialize http mock module
  ptor.addMockModule 'MockedGames', mockModule.mockedGames # Include your mocked data for games endpoints
```

Set the behaviour for your mocked endpoints, this has to be the first thing of your `it` statement
```coffeescript
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
```

#### Endpoints Options
Use the `Mock.endpoint(name, options)` method to set your desired behaviour.

  `name` - The name of the endpoint from the data file (ex `Mock.Games`)
  
  `options` - Array of objects containing configuration data and method specific responses
  
| Option | Type | Description | Required |
| ------ | ---- | ----------- | -------- |
| `passThrough`  | **string** | date later | Yes |
| `arguments`  | **string** | date later | Yes |
| `type`  | **string** | date later | Yes |
| `response`  | **string** | date later | Yes |

  
```
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
```
# Directory Layout

- `mock/init.coffee`
- `mock/http.coffee`

# Contact
For more information on `protractor-mock` hit me up  [@unDemian](https://twitter.com/unDemian)
