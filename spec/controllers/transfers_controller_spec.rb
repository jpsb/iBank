require 'rails_helper'

RSpec.describe Api::V1::TransfersController, :type => :controller do
  let(:source_account)      { FactoryBot.create(:account, number: '1234-5', opening_balance: 100.0) }
  let(:destination_account) { FactoryBot.create(:account, number: '6789-0', opening_balance: 100.0) }
  let(:default_user)        { FactoryBot.create(:user) }

  before { authenticate(default_user) }

  describe "#new transfer" do
    it "should create a transfer" do
      post :create, params: { source_account_number: source_account.number, destination_account_number: destination_account.number, amount: 20.0 }
      expect(response).to have_http_status(:created)
    end

    context "when invalid params" do
      let(:params) do
        { source_account_number: '', destination_account_number: destination_account.number, amount: 20.0 }
      end

      it "show error status" do
        post :create, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "show error message" do
        post :create, params: params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["source_account"]).to include("must exist")
      end
      
    end

  end
end
