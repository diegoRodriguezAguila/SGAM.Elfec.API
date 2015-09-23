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

    context "when the user doesn't exists" do
      before(:each) do
        get :show, id: FFaker::Internet.user_name
      end

      it { should respond_with 404 }
    end
  end
end
