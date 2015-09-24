require 'spec_helper'

describe Api::V1::DevicesController do
  describe 'GET #show' do
    before(:each) do
      @device = FactoryGirl.create :device
      get :show, id: @device.imei
    end

    it 'returns the information about a device' do
      expect(json_response[:imei]).to eql @device.imei
    end

    it { should respond_with :ok }

    context "when the device doesn't exist" do
      before(:each) do
        get :show, id: FFaker::Internet.user_name
      end

      it { should respond_with :not_found }
    end
  end

  describe 'GET #index' do
    before(:each) do
      4.times { FactoryGirl.create :device }
      get :index
    end

    it 'returns 4 records from the database' do
      expect(json_response.size).to eq (4)
    end

    it { should respond_with :ok }
  end

  describe 'POST #create' do

    context 'when is successfully created' do
      before(:each) do
        @device_attributes = FactoryGirl.attributes_for :device
        post :create, { device: @device_attributes }, format: :json
      end

      it 'renders the json representation for the device record just created' do
        expect(json_response[:imei]).to eql @device_attributes[:imei]
      end

      it { should respond_with :created }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_device_attributes = {imei: '' }
        post :create, { device: @invalid_device_attributes }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the device could not be created' do
        expect(json_response[:errors][:imei]).to include 'no puede estar en blanco'
      end

      it { should respond_with :unprocessable_entity }
    end
  end
end
