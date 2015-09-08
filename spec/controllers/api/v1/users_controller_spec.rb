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
end
