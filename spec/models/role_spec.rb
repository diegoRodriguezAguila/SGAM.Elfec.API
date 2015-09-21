require 'spec_helper'

describe Role do
  let(:role) { FactoryGirl.build :role }
  subject { role }

  it { should respond_to(:role) }
  it { should respond_to(:description) }
  it { should respond_to(:status) }
  it { should respond_to(:users) }
  it { should respond_to(:permissions) }
  it { should have_and_belong_to_many :users}
  it { should have_and_belong_to_many :permissions}

  describe 'Validar presencia de nombre de rol y estado y su unicidad' do
    it { should validate_presence_of(:role) }
    it { should validate_uniqueness_of(:role) }
    it { should validate_presence_of(:status) }
  end

end
