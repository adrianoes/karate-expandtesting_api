Feature: User management

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

  @users
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

  @users @negative
  Scenario: Create user - bad request
    * def registerForm =
      """
      {
        name: '#(user_name)',
        email: '@#(user_email)',
        password: '#(user_password)'
      }
      """

    # --- Register - bad request ---
    Given url 'https://practice.expandtesting.com/notes/api/users/register'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields registerForm
    When method post
    Then status 400
    And match response.success == false
    And match response.message == 'A valid email address is required'

  @users
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

  @users @negative
  Scenario: Login user - bad request
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

    # --- Login - bad request ---
    * def loginForm =
      """
      {
        email: '@#(user_email)',
        password: '#(user_password)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/users/login'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields loginForm
    When method post
    Then status 400
    And match response.success == false
    And match response.message == 'A valid email address is required'

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

  @users @negative
  Scenario: Login user - unauthorized
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

    # --- Login - unauthorized ---
    * def loginForm =
      """
      {
        email: '#(user_email)',
        password: '@#(user_password)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/users/login'
    And headers { Accept: 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields loginForm
    When method post
    Then status 401
    And match response.success == false
    And match response.message == 'Incorrect email address or password'

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

  @users
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

  @users @negative
  Scenario: Retrieve user - bad request
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

    # --- Retrieve Info - bad request ---
    Given url 'https://practice.expandtesting.com/notes/api/users/profile'
    And headers { Accept: 'application/json', 'x-auth-token': '@#(user_token)' }
    When method get
    Then status 401
    And match response.success == false
    And match response.message == 'Access token is not valid or has expired, you will need to login'

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  @users
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

  @users @negative
  Scenario: Update user - bad request
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

    # --- Update - bad request ---
    * def updateForm =
      """
      {
        name: '#1a',
        phone: '#(user_phone)',
        company: '#(user_company)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/users/profile'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields updateForm
    When method patch
    Then status 400
    And match response.success == false
    And match response.message == 'User name must be between 4 and 30 characters'

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  @users @negative
  Scenario: Update user - unauthorized
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

    # --- Update - unauthorized ---
    * def updateForm =
      """
      {
        name: '#(user_name)',
        phone: '#(user_phone)',
        company: '#(user_company)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/users/profile'
    And headers { Accept: 'application/json', 'x-auth-token': '@#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields updateForm
    When method patch
    Then status 401
    And match response.success == false
    And match response.message == 'Access token is not valid or has expired, you will need to login'

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  @users
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

  @users @negative
  Scenario: Update user password - bad request
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

    # --- Change Password - bad request ---
    * def passwordChangeForm =
      """
      {
        currentPassword: '#(user_password)',
        newPassword: '123'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/users/change-password'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields passwordChangeForm
    When method post
    Then status 400
    And match response.success == false
    And match response.message == 'New password must be between 6 and 30 characters'

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  @users @negative
  Scenario: Update user password - unauthorized
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

    # --- Change Password - bad request ---
    * def passwordChangeForm =
      """
      {
        currentPassword: '#(user_password)',
        newPassword: '#(user_updated_password)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/users/change-password'
    And headers { Accept: 'application/json', 'x-auth-token': '@#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields passwordChangeForm
    When method post
    Then status 401
    And match response.success == false
    And match response.message == 'Access token is not valid or has expired, you will need to login'

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  @users
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

  @users @negative
  Scenario: Logout user - unauthorized
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

    # --- Logout - unauthorized ---
    Given url 'https://practice.expandtesting.com/notes/api/users/logout'
    And headers { Accept: 'application/json', 'x-auth-token': '@#(user_token)' }
    When method delete
    Then status 401
    And match response.success == false
    And match response.message == 'Access token is not valid or has expired, you will need to login'

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  @users
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

  @users @negative
  Scenario: Delete user - unauthorized
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

    # --- Delete - unauthorized ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '@#(user_token)' }
    When method delete
    Then status 401
    And match response.success == false
    And match response.message == 'Access token is not valid or has expired, you will need to login'

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200
    And match response.success == true
    And match response.message == 'Account successfully deleted'



