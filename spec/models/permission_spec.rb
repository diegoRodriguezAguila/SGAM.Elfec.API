require 'spec_helper'

describe Permission do
  let(:permission) { FactoryGirl.build :permission }
  subject { permission }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:status) }
  it { should respond_to(:roles) }
  it { should have_and_belong_to_many :roles}

  describe 'Validar presencia de nombre de permiso, estado y su unicidad' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:status) }
  end
end
