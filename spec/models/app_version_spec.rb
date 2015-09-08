require 'spec_helper'

describe AppVersion do
  let(:app_version) { FactoryGirl.build :app_version }
  subject { app_version }
  it { should respond_to(:application) }
  it { should respond_to(:version) }
  it { should respond_to(:version_code) }
  it { should respond_to(:status) }
  it { should belong_to :application }

  describe 'Validar presencia de nombre, paquete, version url y estado' do
    it { should validate_presence_of(:application) }
    it { should validate_presence_of(:version) }
    it { should validate_presence_of(:version_code) }
    it { should validate_numericality_of(:version_code) }
    it { should validate_presence_of(:status) }
  end
end
