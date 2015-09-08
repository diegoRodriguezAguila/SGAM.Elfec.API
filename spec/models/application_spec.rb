require 'spec_helper'

describe Application do
  let(:application) { FactoryGirl.build :application }
  subject { application }

  it { should respond_to(:name) }
  it { should respond_to(:app_versions) }
  it { should respond_to(:package) }
  it { should respond_to(:url) }
  it { should respond_to(:icon_url) }
  it { should respond_to(:status) }
  it { should have_many(:app_versions) }

  describe 'Validar presencia de nombre, paquete, version url y estado' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:app_versions) }
    it { should validate_presence_of(:package) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:status) }
  end

  describe 'Validar unicidad de nombre y paquete' do
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:package) }
  end
  describe '#app version association' do

    before do
      @application = FactoryGirl.create(:application)
      @application.save
      3.times { FactoryGirl.create :app_version, application: @application }
    end

    it 'destroys the associated app versions on self destruct' do
      versions =  @application.app_versions
      @application.destroy
      versions.each do |version|
        expect(AppVersion.find(version)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
