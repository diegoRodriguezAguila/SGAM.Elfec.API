require 'spec_helper'
#encoding: UTF-8
describe Api::V1::SessionsController do
  describe 'POST #create' do

    before(:each) do
      @auth_user = FactoryGirl.create(:user, :authenticated)
      @user = FactoryGirl.create :user
    end

    context 'when the credentials are correct' do

      before(:each) do
        credentials = { username: @auth_user.username, password: @auth_user.password }
        post :create, { session: credentials }
      end

      it 'returns the user record corresponding to the given credentials' do
        @user.reload
        expect(json_response[:authentication_token]).to eql @auth_user.authentication_token
      end

      it { should respond_with 200 }
    end

    context 'when the credentials are incorrect' do

      before(:each) do
        credentials = { username: @user.username, password: @user.password }
        post :create, { session: credentials }
      end

      it 'returns a json with an error' do
        expect(json_response[:errors]).to eql 'El Usuario o password proporcionados no son válidos, por favor revise los datos e inténtelo nuevamente'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do

    before(:each) do
      @user = FactoryGirl.create(:user, :authenticated)
      sign_in @user
      delete :destroy, id: @user.authentication_token
    end

    it { should respond_with 204 }

  end
end
