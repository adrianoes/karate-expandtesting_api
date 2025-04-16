Feature: Notes API Health Check

  Background:
    * def baseUrl = 'https://practice.expandtesting.com/notes/api'
    * url baseUrl
    * def defaultHeaders = { Accept: 'application/json' }
    * def healthCheckResponse =
      """
      {
        success: true,
        status: 200,
        message: 'Notes API is Running'
      }
      """

  Scenario: Validar resposta do health-check
    Given path 'health-check'
    And headers defaultHeaders
    When method get
    Then status 200
    And match response.success == healthCheckResponse.success
    And match response.status == healthCheckResponse.status
    And match response.message == healthCheckResponse.message
