require 'spec_helper'
require 'ffaker'
#encoding: UTF-8
describe Api::V1::UsersController do
  describe 'GET #show' do

    context 'when the user exists' do
      before(:each) do
        @user = FactoryGirl.create(:user, :authenticated)
        get :show, id: @user.username
      end
      it 'returns the information about a user' do
        expect(json_response[:username]).to eql @user.username
      end
      it { should respond_with 200 }
    end

    context "when the user doesn't exists" do
      before(:each) do
        get :show, id: FFaker::Internet.user_name
      end

      it { should respond_with 404 }
    end

  end

  describe 'POST #create' do

    context 'when is successfully created' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        expect(json_response[:username]).to eql @user_attributes[:username]
      end

      it { should respond_with :created }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_user_attributes = {username: '' }
        post :create, { user: @invalid_user_attributes }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        expect(json_response[:errors][:username]).to include 'no puede estar en blanco'
      end

      it { should respond_with :unprocessable_entity }
    end
  end
end
