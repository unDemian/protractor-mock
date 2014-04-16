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
3. Done `:]` (there is an example scenario file in the repo `example.spec.coffee`)


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
  | `response.*` | **object** | You can attach custom response messages to be referenced later as `Mock.name.response.xxx` | - |

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

Add required mock modules in your `beforeEach` statement
```coffeescript
  # Clear loaded mock modules
  ptor.clearMockModules() 
  
  # Initialize http mock module
  ptor.addMockModule 'httpBackendMockInit', mockModule.httpBackendMockInit 
  
  # Include your mocked data for games endpointsm you can add as many as you need
  ptor.addMockModule 'MockedGames', mockModule.mockedGames 
```

Set the behaviour for your mocked endpoints, this has to be the first thing of your `it` statement
```coffeescript
    # Update behaviour for mocked endpoints
    ptor.addMockModule 'httpBackendMockUpdate', () ->
      angular.module('httpBackendMockUpdate', []).run ['Mock', (Mock) ->
        Mock.endpoint(Mock.games, [
          {
            get:
              response:
                code: 200
                content: 'Yes!'
          }
          {
            get:
              arguments: '/all'
              response: Mock.entity.response.error.notFound
            put:
              response: Mock.entity.response.success
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
  
| Option | Type | Description | Required | Default |
| ------ | ---- | ----------- | -------- | ------- |
| `passThrough`  | **boolean** | Ignore mocking, pass the request to your api | No | false |
| `arguments`  | **string** | Parameters to be concatenated to your endpoint url | No | - |
| `type`  | **object** | Type of returned data, values `Mock.element`, `Mock.object`, `Mock.array`  | No | - |
| `response`  | **object** | Actual response data, you can use `Mock.games.response.*` objects | Yes | - |


**NOTES**

`options` argument is an array of response objects, this way you can mock multiple endpoint variations. Also for each response object, you can set the behaviour for all the http available methods (i.e. `get`, `post`, `put`, `delete`).

If you select `Mock.element` as your type, and your `response.data` is an array the mocked endpoint will return the first element of the array.

As your response you can use one of your objects declared in the data file or you can create one on the fly, below you can see the properties of an `response` object.

| Option | Type | Description | Required | Default |
| ------ | ---- | ----------- | -------- | ------- |
| `code`  | **integer** | Returned http status code | Yes | 200 |
| `content`  | **object** | Actual response string or json object | Yes | - |
| `headers`  | **array** | An array containing headers that you want to mock  | No | - |

# Contact
For more information on `protractor-mock` hit me up  [@unDemian](https://twitter.com/unDemian)
