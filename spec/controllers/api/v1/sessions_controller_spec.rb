require 'spec_helper'

describe Api::V1::SessionsController do
  describe "POST #create" do

    before(:each) do
      @auth_user = FactoryGirl.create(:user, :authenticated)
      @user = FactoryGirl.create :user
    end

    context "when the credentials are correct" do

      before(:each) do
        credentials = { username: @auth_user.username, password: @auth_user.password }
        post :create, { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response[:user][:authentication_token]).to eql @auth_user.authentication_token
      end

      it { should respond_with 200 }
    end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = { username: @user.username, password: @user.password }
        post :create, { session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eql "Usuario o password incorrectos!"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do

    before(:each) do
      @user = FactoryGirl.create(:user, :authenticated)
      sign_in @user
      delete :destroy, id: @user.authentication_token
    end

    it { should respond_with 204 }

  end
end
