### Documentation:


Instructions on how to build/run your application

Pre-requisites:
1. Latest version of redis and docker needs to be installed

Run the following commands in your terminal:

1. 'cd /path/to/task_app'
1. 'rvm gemset create task_app'
1. 'rvm gemset use task_app'
1. 'rvm gemset list' to verify (optional)
1. 'bundle install'
1. 'yarn install --check-files'
1. redis-server
1. Running test-cases:
   - 'bundle exec rspec --format documentation'
1. Starting the application
   - docker-compose up --build
1. To create user send request in the following format:
    - 'post '/api/users/create', params: { 'user': {'username': 'test', 'password': '1234578'} }, headers: { 'Content-Type': 'application/json', 'HTTP_API_KEY': 'f294440ff51973cc255e908b8dac234a931c8494' }'
1. To login user send request in the following format:
    - 'post "/api/users/login", params: { 'user': { 'username': 'test', 'password': '1234578' } }, headers: { 'Content-Type': 'application/json', 'HTTP_API_KEY': 'f294440ff51973cc255e908b8dac234a931c8494' }''
1. Use the jwt response token from the two api responses for future requests.


