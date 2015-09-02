require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:password) }
  it { should be_valid }

  describe "Cuando no hay username" do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end
end
