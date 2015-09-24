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

    it { should respond_with 200 }

    context "when the device doesn't exist" do
      before(:each) do
        get :show, id: FFaker::Internet.user_name
      end

      it { should respond_with 404 }
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

    it { should respond_with 200 }
  end
end
