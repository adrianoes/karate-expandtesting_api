Feature: Teste de registro de usuário

  Background:
    * def user_name = 'VegetaPrince'
    * def user_email = 'vegeta123@capsulecorp2.com'
    * def user_password = 'saiyan123'

  Scenario: Criar, logar e deletar usuário com sucesso
    * def registerForm =
      """
      {
        name: '#(user_name)',
        email: '#(user_email)',
        password: '#(user_password)'
      }
      """

    # --- Registro ---
    Given url 'https://practice.expandtesting.com/notes/api/users/register'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields registerForm
    When method post
    Then status 201
    And match response.success == true
    And match response.message == 'User account created successfully'
    And match response.data.name == user_name
    And match response.data.email == user_email
    * def user_id = response.data.id
    * print 'User ID registrado:', user_id

    # --- Login ---
    * def loginForm =
      """
      {
        email: '#(user_email)',
        password: '#(user_password)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/users/login'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields loginForm
    When method post
    Then status 200
    And match response.success == true
    And match response.message == 'Login successful'
    And match response.data.name == user_name
    And match response.data.email == user_email
    And match response.data.id == user_id
    * def user_token = response.data.token
    * print 'Token recebido:', user_token

    # --- Deleção ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200
    And match response.success == true
    And match response.message == 'Account successfully deleted'

