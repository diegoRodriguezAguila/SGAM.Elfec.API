require 'spec_helper'

describe Role do
  let(:role) { FactoryGirl.build :role }
  subject { role }

  it { should respond_to(:role) }
  it { should respond_to(:description) }
  it { should respond_to(:status) }
  it { should respond_to(:users) }
end
