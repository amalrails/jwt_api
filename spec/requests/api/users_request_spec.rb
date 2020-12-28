require 'rails_helper'

RSpec.describe "Api::Users", type: :request do

  describe "POST /login" do
    let(:user_params1) { { user: { 'username': 'test', 'password': '1234578' } } }

    it 'returns http success' do
        post '/api/users/create', params: user_params1.to_json, headers: { 'Content-Type': 'application/json', 'HTTP_API_KEY': 'f294440ff51973cc255e908b8dac234a931c8494' }
        post '/api/users/login', params: user_params1.to_json,
                                   headers: { 'Content-Type': 'application/json',
                                              'HTTP_API_KEY': 'f294440ff51973cc255e908b8dac234a931c8494' }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    let(:user_params1) { { user: { 'username': 'test5', 'password': '1234578' } } }

    it "returns http success" do
      post "/api/users/create", params: user_params1.to_json, headers: { 'Content-Type': 'application/json', 'HTTP_API_KEY': 'f294440ff51973cc255e908b8dac234a931c8494' }
      expect(response).to have_http_status(:success)
    end
  end

end
