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
    * def note_title = user.noteTitle
    * def note_description = user.noteDescription
    * def note_category = user.noteCategory
    * def note_updated_title = user.noteUpdatedTitle
    * def note_updated_description = user.noteUpdatedDescription
    * def note_updated_category = user.noteUpdatedCategory
    * def note_updated_completed = user.noteUpdatedCompleted
    * def note_title_2 = user.noteTitle2
    * def note_description_2 = user.noteDescription2
    * def note_category_2 = user.noteCategory2

  Scenario: Create note
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

    # --- Create Note ---
    * def noteForm =
      """
      {
        title: '#(note_title)',
        description: '#(note_description)',
        category: '#(note_category)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/notes'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields noteForm
    When method post
    Then status 200
    And match response.success == true
    And match response.message == 'Note successfully created'
    And match response.data.title == note_title
    And match response.data.description == note_description
    And match response.data.category == note_category
    And match response.data.user_id == user_id
    * def note_id = response.data.id
    * def note_completed = response.data.completed
    * def note_created_at = response.data.created_at
    * def note_updated_at = response.data.updated_at

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Retrieve all notes
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

    # --- Create First Note ---
    * def noteForm =
      """
      {
        title: '#(note_title)',
        description: '#(note_description)',
        category: '#(note_category)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/notes'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields noteForm
    When method post
    Then status 200
    * def note_id = response.data.id
    * def note_completed = response.data.completed
    * def note_created_at = response.data.created_at
    * def note_updated_at = response.data.updated_at

    # --- Create Second Note ---
    * def noteForm2 =
      """
      {
        title: '#(note_title_2)',
        description: '#(note_description_2)',
        category: '#(note_category_2)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/notes'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields noteForm2
    When method post
    Then status 200
    * def note_id_2 = response.data.id
    * def note_completed_2 = response.data.completed
    * def note_created_at_2 = response.data.created_at
    * def note_updated_at_2 = response.data.updated_at

    # --- Retrieve All Notes ---
    Given url 'https://practice.expandtesting.com/notes/api/notes'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method get
    Then status 200
    And match response.success == true
    And match response.message == 'Notes successfully retrieved'

    # --- Assertions for First Note (data[1]) ---
    And match response.data[1].id == note_id
    And match response.data[1].title == note_title
    And match response.data[1].description == note_description
    And match response.data[1].category == note_category
    And match response.data[1].completed == note_completed
    And match response.data[1].created_at == note_created_at
    And match response.data[1].updated_at == note_updated_at
    And match response.data[1].user_id == user_id

    # --- Assertions for Second Note (data[0]) ---
    And match response.data[0].id == note_id_2
    And match response.data[0].title == note_title_2
    And match response.data[0].description == note_description_2
    And match response.data[0].category == note_category_2
    And match response.data[0].completed == note_completed_2
    And match response.data[0].created_at == note_created_at_2
    And match response.data[0].updated_at == note_updated_at_2
    And match response.data[0].user_id == user_id

    # --- Delete User Account ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Retrieve note
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

    # --- Create Note ---
    * def noteForm =
      """
      {
        title: '#(note_title)',
        description: '#(note_description)',
        category: '#(note_category)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/notes'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields noteForm
    When method post
    Then status 200
    * def note_id = response.data.id
    * def note_completed = response.data.completed
    * def note_created_at = response.data.created_at
    * def note_updated_at = response.data.updated_at

    # --- Retrieve Note ---
    Given url 'https://practice.expandtesting.com/notes/api/notes/' + note_id
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method get
    Then status 200
    And match response.success == true
    And match response.message == 'Note successfully retrieved'
    And match response.data.id == note_id
    And match response.data.title == note_title
    And match response.data.description == note_description
    And match response.data.category == note_category
    And match response.data.completed == note_completed
    And match response.data.created_at == note_created_at
    And match response.data.updated_at == note_updated_at
    And match response.data.user_id == user_id

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Update note
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

    # --- Create Note ---
    * def noteForm =
      """
      {
        title: '#(note_title)',
        description: '#(note_description)',
        category: '#(note_category)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/notes'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields noteForm
    When method post
    Then status 200
    * def note_id = response.data.id
    * def note_created_at = response.data.created_at

    # --- Update Note ---
    * def noteUpdateForm =
      """
      {
        title: '#(note_updated_title)',
        description: '#(note_updated_description)',
        completed: '#(note_updated_completed)',
        category: '#(note_updated_category)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/notes/' + note_id
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields noteUpdateForm
    When method put
    Then status 200
    And match response.success == true
    And match response.message == 'Note successfully Updated'
    And match response.data.id == note_id
    And match response.data.title == note_updated_title
    And match response.data.description == note_updated_description
    And match response.data.category == note_updated_category
    And match response.data.completed == note_updated_completed
    And match response.data.created_at == note_created_at
    And match response.data.user_id == user_id
    * def note_updated_at = response.data.updated_at

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Update note status
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

    # --- Create Note ---
    * def noteForm =
      """
      {
        title: '#(note_title)',
        description: '#(note_description)',
        category: '#(note_category)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/notes'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields noteForm
    When method post
    Then status 200
    * def note_id = response.data.id
    * def note_title_created = response.data.title
    * def note_description_created = response.data.description
    * def note_category_created = response.data.category
    * def note_created_at = response.data.created_at

    # --- Patch Note Completed Status ---
    * def patchCompletedForm =
      """
      {
        completed: '#(note_updated_completed)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/notes/' + note_id
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields patchCompletedForm
    When method patch
    Then status 200
    And match response.success == true
    And match response.message == 'Note successfully Updated'
    And match response.data.id == note_id
    And match response.data.completed == note_updated_completed
    And match response.data.title == note_title_created
    And match response.data.description == note_description_created
    And match response.data.category == note_category_created
    And match response.data.created_at == note_created_at
    And match response.data.user_id == user_id
    * def note_updated_at = response.data.updated_at

    # --- Delete ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200

  Scenario: Delete note
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

    # --- Create Note ---
    * def noteForm =
      """
      {
        title: '#(note_title)',
        description: '#(note_description)',
        category: '#(note_category)'
      }
      """
    Given url 'https://practice.expandtesting.com/notes/api/notes'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)', 'Content-Type': 'application/x-www-form-urlencoded' }
    * form fields noteForm
    When method post
    Then status 200
    * def note_id = response.data.id

    # --- Delete Note ---
    Given url 'https://practice.expandtesting.com/notes/api/notes/' + note_id
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200
    And match response.success == true
    And match response.message == 'Note successfully deleted'

    # --- Delete User Account ---
    Given url 'https://practice.expandtesting.com/notes/api/users/delete-account'
    And headers { Accept: 'application/json', 'x-auth-token': '#(user_token)' }
    When method delete
    Then status 200
