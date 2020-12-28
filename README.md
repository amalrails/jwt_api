### Documentation:

Using Ruby on Rails as framework and Redis for data storage,  this is an authentication API for internal services to create and authenticate users. This API is RESTful and uses JSON. It is fast and secure, and will be able to pass a basic security audit (e.g. password complexity). The API will be able to create a new login with a username and password, ensuring that usernames are unique. It is also able to authenticate this login at a separate end point. It should respond with 200 OK messages for correct requests, and 401 for failing authentication requests. It should do proper error checking, with error responses in a JSON response body.

Instructions on how to build/run your application

Pre-requisites:
1. Latest version of docker needs to be installed

Run the following commands in your terminal:

1. 'cd /path/to/task_app'
1. 'rvm gemset create task_app'
1. 'rvm gemset use task_app'
1. 'rvm gemset list' to verify (optional)
1. 'bundle install'
1. 'yarn install --check-files'
1. Running test-cases:
   - 'bundle exec rspec --format documentation'
1. Starting the application
   - docker-compose up --build
1. To create user use the following steps:
    - 'post '/api/users/create', params: { "user": {"username": "test", "password": "1234578"}}, headers: { 'Content-Type': 'application/json', 'HTTP_API_KEY': 'f294440ff51973cc255e908b8dac234a931c8494' }'
1. Open any browser and go to http://localhost:3000/
1. Login to the application using username: 'admin@gmail.com', password: 'admin123'.
1. Login to another user account using username: 'user@gmail.com', password: 'user123'.
1. Use New task link to create new task for the signed in user.
1. Use Users info link to fetch the different users list and tasks list created by other users, but can only see the tasks and not perform any other actions.
1. Use MyTasks link to see the tasks created by the current user.
1. You can click on the priority link on index page and sort the list according to the priorities.
1. You can use the edit, show, and destroy options against each task also.


