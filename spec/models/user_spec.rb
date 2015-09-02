require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:password) }
  # we test the user actually respond to this attribute
  it { should respond_to(:authentication_token) }
  it { should be_valid }

  describe "Cuando no hay username" do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end

  describe "Auth token es unico" do
    # we test the auth_token is unique
    it { should validate_uniqueness_of(:authentication_token)}
  end

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      Devise.stub(:friendly_token).and_return("auniquetoken123")
      @user.ensure_authentication_token
      expect(@user.authentication_token).to eql "auniquetoken123"
    end

    it "Genera otro token cuando uno ya existe" do
      existing_user = FactoryGirl.create(:user, authentication_token: "auniquetoken123")
      @user.ensure_authentication_token
      expect(@user.authentication_token).not_to eql existing_user.authentication_token
    end
  end
end
