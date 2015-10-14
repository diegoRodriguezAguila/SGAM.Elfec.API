require 'spec_helper'
#encoding: UTF-8
describe Api::V1::DevicesController do
  before(:each) do
    @auth_user = FactoryGirl.create(:user, :authenticated)
    request.headers['X-Api-Username'] = @auth_user.username
    request.headers['X-Api-Token'] = @auth_user.authentication_token
  end
  describe 'GET #show' do
    before(:each) do
      @device = FactoryGirl.create :device
      get :show, id: @device.imei
    end

    it 'returns the information about a device' do
      expect(json_response[:imei]).to eql @device.imei
    end

    it { expect(response).to have_http_status(:ok) }

    context "when the device doesn't exist" do
      before(:each) do
        get :show, id: FFaker::Internet.user_name
      end

      it { expect(response).to have_http_status(:not_found) }
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

    it { expect(response).to have_http_status(:ok) }
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

      it { expect(response).to have_http_status(:created) }
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

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'PUT/PATCH #update' do

    context 'when is successfully updated' do
      before(:each) do
        @device = FactoryGirl.create :device
        patch :update, { id: @device.imei,
                         device: { name: 'ELFEC0023', phone_number: '72831222'} }, format: :json
      end

      it 'renders the json representation for the updated device' do
        expect(json_response[:name]).to eql 'ELFEC0023'
        expect(json_response[:phone_number]).to eql '72831222'
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when is not created' do
      before(:each) do
        @device = FactoryGirl.create :device
        patch :update, { id: @device.imei,
                         device: { phone_number: 'not_a_number_!2312'} }, format: :json
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on why the device could not be created' do
        expect(json_response[:errors][:phone_number]).to include 'no es un número'
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end
end
