require 'spec_helper'

describe Api::V1::ApplicationsController do

  before(:each) do
    @auth_user = FactoryGirl.create(:user, :authenticated)
    request.headers['X-Api-Username'] = @auth_user.username
    request.headers['X-Api-Token'] = @auth_user.authentication_token
  end

  describe 'GET #show' do
    before(:each) do
      @app = FactoryGirl.create :application
      get :show, id: @app.package
    end

    it 'returns the information about an app' do
      expect(json_response[:package]).to eql @app.package
    end

    it { expect(response).to have_http_status(:ok) }

    context "when the app doesn't exist" do
      before(:each) do
        get :show, id: FFaker::CompanySE.name
      end

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
