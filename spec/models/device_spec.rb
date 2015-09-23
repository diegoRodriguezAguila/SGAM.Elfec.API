require 'spec_helper'

describe Device do
  let(:device) { FactoryGirl.build :device }
  subject { device }

  it { should respond_to(:name) }
  it { should respond_to(:imei) }
  it { should respond_to(:serial) }
  it { should respond_to(:mac_address) }
  it { should respond_to(:platform) }
  it { should respond_to(:os_version) }
  it { should respond_to(:brand) }
  it { should respond_to(:model) }
  it { should respond_to(:phone_number) }
  it { should respond_to(:screen_size) }
  it { should respond_to(:screen_resolution) }
  it { should respond_to(:camera) }
  it { should respond_to(:sd_memory_card) }
  it { should respond_to(:status) }

  describe 'Validar presencia de atributos obligatorios' do
    it { should validate_presence_of(:imei) }
    it { should validate_presence_of(:serial) }
    it { should validate_presence_of(:mac_address) }
    it { should validate_presence_of(:platform) }
    it { should validate_presence_of(:os_version) }
    it { should validate_presence_of(:brand) }
    it { should validate_presence_of(:model) }
    it { should validate_presence_of(:status) }
  end

  describe 'Validar unicidad de atributos' do
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:imei) }
    it { should validate_uniqueness_of(:mac_address) }
  end

  describe 'Validar numeralidad de atributos' do
    it { should validate_numericality_of(:imei) }
    it { should validate_numericality_of(:phone_number) }
  end
end
