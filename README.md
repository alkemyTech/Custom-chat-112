# Custom Chat OT112

This API provides full access to all backend capabilities of the chat service.

Mainly, is composed by 3 user-accesible features.

*   Chats
*   Users
*   Messages


For the first use, you need to register. After this, or after log in with your credentials, you will get an Authorization token, this is necessary to almost all actions.

## Users
### Model & body format

Body format applies only to update and create action. Create is an alias for Auth/register.

* **name** (obligatory) of type string
* **email** (obligatory)  of type string
* **password** (obligatory)  of type string

Headers
* **Key**: "Authorization"
* **Value**: "yourtoken"

### Endpoints
##### GET /users

This endpoint returns all users listed.


##### PATCH /users/:id

This is the endpoint used to update an user. To do so, provide the user ID in URL.


##### DELETE /users/:id

This is the endpoint used to delete an user. To do so, provide the user ID in URL.
Using this endpoint will hard-delete the user.

## Conversations

* Section in process

## Messages

### Model & body format
Body format applies only to create and update actions
* **User_id** (obligatory) of type integer
* **Detail** (obligatory) of type string
* **Modified** of type boolean

Headers
* **Key**: "Authorization"
* **Value**: "yourtoken"

### Endpoints
##### GET /conversations/:conversation_id/messages

This endpoint returns the first page of messagse with a total of ten elements. To see the next ten, you can type the url parameter "page=n" with n being the page number. Before that, the conversation where messages persist, is found by the :id


##### POST /messages

This is the endpoint used to create new messages. The body format is form-data and allows the following values:


* **user_id** \*
* **detail**
* **modified**


\* *user_id is setted using current_user method provided by session_helper in Rails*

### Parameters
* page: with this parameter you can specify the page you want to see. It returns the first ten elements with page one by default.

## Authentication Documentation

### Model & body format

"Register" action need this three parameters. To perform the "login" action we will need email and password only.

*   **name** (obligatory) of type string
*   **email** (obligatory and unique) of type string
*   **password** (obligatory) of type string

