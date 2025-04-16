Feature: Teste de registro de usuário

  Background:
    * def fakerUtils = Java.type('utils.FakerUtils')
    * def user = fakerUtils.generateUserData()
    * def user_name = user.name
    * def user_email = user.email
    * def user_password = user.password
    * def user_updated_name = user.updatedName
    * def user_phone = user.phone
    * def user_company = user.company
    * def user_updated_password = user.updatedPassword

  Scenario: Create user
    * def registerForm =
      """
      {
        name: '#(user_name)',
        email: '#(user_email)',
        password: '#(user_password)'
      }
      """

    # --- Register ---
    Given url 'https://practice.expandtesting.com/notes/api/users/register'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields registerForm
    When method post
    Then status 201
    And match response.success == true
    And match response.message == 'User account created successfully'
    And match response.data.name == user_name
    And match response.data.email == user_email

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
    * def user_token = response.data.token

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Login user
    * def registerForm =
      """
      {
        name: '#(user_name)',
        email: '#(user_email)',
        password: '#(user_password)'
      }
      """

    # --- Register ---
    Given url 'https://practice.expandtesting.com/notes/api/users/register'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields registerForm
    When method post
    Then status 201
    * def user_id = response.data.id

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

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Retrieve user
    * def registerForm =
      """
      {
        name: '#(user_name)',
        email: '#(user_email)',
        password: '#(user_password)'
      }
      """

    # --- Register ---
    Given url 'https://practice.expandtesting.com/notes/api/users/register'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields registerForm
    When method post
    Then status 201
    * def user_id = response.data.id

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
    * def user_token = response.data.token

    # --- Retrieve Info ---
    Given url 'https://practice.expandtesting.com/notes/api/users/profile'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method get
    Then status 200
    And match response.success == true
    And match response.message == 'Profile successful'
    And match response.data.id == user_id
    And match response.data.name == user_name
    And match response.data.email == user_email

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Update user
    * def registerForm =
      """
      {
        name: '#(user_name)',
        email: '#(user_email)',
        password: '#(user_password)'
      }
      """

    # --- Register ---
    Given url 'https://practice.expandtesting.com/notes/api/users/register'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields registerForm
    When method post
    Then status 201
    * def user_id = response.data.id

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
    * def user_token = response.data.token

    # --- Update ---
    * def updateForm =
      """
      {
        name: '#(user_updated_name)',
        phone: '#(user_phone)',
        company: '#(user_company)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/users/profile'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields updateForm
    When method patch
    Then status 200
    And match response.success == true
    And match response.message == 'Profile updated successful'
    And match response.data.id == user_id
    And match response.data.name == user_updated_name
    And match response.data.email == user_email
    And match response.data.phone == user_phone
    And match response.data.company == user_company

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Update user password
    * def registerForm =
      """
      {
        name: '#(user_name)',
        email: '#(user_email)',
        password: '#(user_password)'
      }
      """

    # --- Register ---
    Given url 'https://practice.expandtesting.com/notes/api/users/register'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields registerForm
    When method post
    Then status 201
    * def user_id = response.data.id

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
    * def user_token = response.data.token

    # --- Change Password ---
    * def passwordChangeForm =
      """
      {
        currentPassword: '#(user_password)',
        newPassword: '#(user_updated_password)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/users/change-password'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields passwordChangeForm
    When method post
    Then status 200
    And match response.success == true
    And match response.message == 'The password was successfully updated'

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Logout user
    * def registerForm =
      """
      {
        name: '#(user_name)',
        email: '#(user_email)',
        password: '#(user_password)'
      }
      """

    # --- Register ---
    Given url 'https://practice.expandtesting.com/notes/api/users/register'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields registerForm
    When method post
    Then status 201
    * def user_id = response.data.id

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
    * def user_token = response.data.token

    # --- Logout ---
    Given url 'https://practice.expandtesting.com/notes/api/users/logout'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200
    And match response.success == true
    And match response.message == 'User has been successfully logged out'

    # --- Login ---
    * def reLoginForm =
      """
      {
        email: '#(user_email)',
        password: '#(user_password)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/users/login'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields reLoginForm
    When method post
    Then status 200
    * def user_token = response.data.token

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Delete user
    * def registerForm =
      """
      {
        name: '#(user_name)',
        email: '#(user_email)',
        password: '#(user_password)'
      }
      """

    # --- Register ---
    Given url 'https://practice.expandtesting.com/notes/api/users/register'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields registerForm
    When method post
    Then status 201

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
    * def user_token = response.data.token

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200
    And match response.success == true
    And match response.message == 'Account successfully deleted'



