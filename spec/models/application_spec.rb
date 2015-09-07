require 'spec_helper'

describe Application do
  let(:application) { FactoryGirl.build :application }
  subject { application }

  it { should respond_to(:name) }
  it { should respond_to(:version) }
  it { should respond_to(:package) }
  it { should respond_to(:url) }
  it { should respond_to(:icon_url) }
  it { should respond_to(:status) }

  describe 'Validar presencia de nombre, paquete, version url y estado' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:version) }
    it { should validate_presence_of(:package) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:status) }
  end
end
