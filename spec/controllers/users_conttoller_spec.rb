require 'rails_helper'

RSpec.describe Api::UsersController , type: :controller do
  before(:each) {Redis.new.FLUSHALL}
  describe 'post #create' do
    let(:response_body) { JSON.parse(response.body) }

    context 'User creation successfull' do
      let(:user_params1) { { user: { 'username': 'test', 'password': '1234578' } } }
      let(:user_params2) { { user: { 'username': 'test2', 'password': '1234578' } } }

      it 'returns http success' do
        request.headers['Content-Type'] = 'application/json'
        request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
        post :create, params: user_params1

        expect(response).to have_http_status(:success)
      end

      it 'returns http success message' do
        request.headers['Content-Type'] = 'application/json'
        request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
        post :create, params: user_params2

        expect(response_body['message']).to eq('User created!!')
      end

      it 'returns auth_token' do
        request.headers['Content-Type'] = 'application/json'
        request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
        post :create, params: user_params1

        expect(response_body['auth_token']).not_to be_nil
      end

      it 'adds the user to redis' do
        request.headers['Content-Type'] = 'application/json'
        request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
        post :create, params: user_params2

        expect(Redis.new.get('test2')).not_to be_nil
      end

      it 'encrypts and stores the user password to redis' do
        request.headers['Content-Type'] = 'application/json'
        request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
        post :create, params: user_params2

        bcrypt_obj = BCrypt::Password.new(Redis.new.get('test2'))
        expect(bcrypt_obj == '1234578').to be true
      end
    end

    context 'User creation unsuccessfull' do
      context 'Password length is too small' do
        let(:user_params) { { user: { 'username': 'test5', 'password': '4578' } } }

        it 'returns status 422' do
          request.headers['Content-Type'] = 'application/json'
          request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
          post :create, params: user_params

          expect(response.status).to eq(422)
        end

        it 'returns message Password length too small' do
          request.headers['Content-Type'] = 'application/json'
          request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
          post :create, params: user_params

          expect(response_body['errors']).to eq('Password length too small')
        end
      end

      context 'User already exist' do
        let(:user_params) { { user: { 'username': 'test5', 'password': '4578888' } } }

        it 'returns status 422' do
          request.headers['Content-Type'] = 'application/json'
          request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
          post :create, params: user_params
          post :create, params: user_params

          expect(response.status).to eq(422)
        end

        it 'returns message User already exists' do
          request.headers['Content-Type'] = 'application/json'
          request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
          post :create, params: user_params
          post :create, params: user_params

          expect(response_body['errors']).to eq('User already exists')
        end
      end

      context 'Invalid api key' do
        let(:user_params) { { user: { 'username': 'test5', 'password': '4578' } } }

        it 'returns status 422' do
          request.headers['Content-Type'] = 'application/json'
          request.headers['HTTP_API_KEY'] = ''

          post :create, params: user_params

          expect(response.status).to eq(401)
        end

        it 'returns message Unauthorized Request' do
          request.headers['Content-Type'] = 'application/json'
          request.headers['HTTP_API_KEY'] = ''
          post :create, params: user_params

          expect(response_body['error']).to eq('Unauthorized Request')
        end
      end
    end
  end

  describe 'post #login' do
    let(:response_body) { JSON.parse(response.body) }
    context 'Successfull' do
      let(:user_params) { { user: { 'username': 'test8', 'password': '4578888' } } }
      it 'returns http success' do
        request.headers['Content-Type'] = 'application/json'
        request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
        post :create, params: user_params
        post :login, params: user_params

        expect(response).to have_http_status(:success)
      end

      it 'returns success message' do
        request.headers['Content-Type'] = 'application/json'
        request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
        post :create, params: user_params
        post :login, params: user_params

        expect(response_body['message']).to eq('Authentication Successful')
      end

      it 'returns auth_token' do
        request.headers['Content-Type'] = 'application/json'
        request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
        post :create, params: user_params
        post :login, params: user_params

        expect(response_body['auth_token']).not_to be_nil
      end
    end

    context 'Unsuccessfull' do
      context 'wrong username/password' do
        let(:user_params) { { user: { 'username': 'test8', 'password': '4578888' } } }
        let(:user_params1) { { user: { 'username': 'test8', 'password': '5555555' } } }
        it 'returns http 401' do
          request.headers['Content-Type'] = 'application/json'
          request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
          post :create, params: user_params
          post :login, params: user_params1

          expect(response).to have_http_status(401)
        end

        it 'returns message Invalid username/password' do
          request.headers['Content-Type'] = 'application/json'
          request.headers['HTTP_API_KEY'] = 'f294440ff51973cc255e908b8dac234a931c8494'
          post :create, params: user_params
          post :login, params: user_params1

          expect(response_body['error']).to eq('Invalid username/password')
        end
      end

      context 'Invalid api key' do
        let(:user_params) { { user: { 'username': 'test5', 'password': '4578' } } }

        it 'returns status 422' do
          request.headers['Content-Type'] = 'application/json'
          request.headers['HTTP_API_KEY'] = ''
          post :login, params: user_params
          expect(response.status).to eq(401)
        end

        it 'returns message Unauthorized Request' do
          request.headers['Content-Type'] = 'application/json'
          request.headers['HTTP_API_KEY'] = ''
          post :login, params: user_params
          expect(response_body['error']).to eq('Unauthorized Request')
        end
      end
    end
  end
end
