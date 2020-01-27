require 'rails_helper'

RSpec.describe Api::V1::AccountsController, :type => :controller do
  let(:account1)     { FactoryBot.create(:account, number: '1234-5', opening_balance: 100.0) }
  let(:default_user) { FactoryBot.create(:user) }

  before { authenticate(default_user) }

  describe "#new account" do
    it "should create account" do
      post :create, params: { number: '9999-9', opening_balance: 45.0 }
      expect(response).to have_http_status(:created)
    end

    it "should show errors when account number is taken" do
      post :create, params: { number: account1.number, opening_balance: 45.0 }
      expect(response).to have_http_status(:unprocessable_entity)
      status_info = JSON.parse(response.body)
      expect(status_info['number']).to include('has already been taken')
    end
  end

  describe "#balance" do
    it "should show the account balance" do
      post :balance, params: { account_number: account1.number }
      expect(response).to have_http_status(:ok)

      account_info = JSON.parse(response.body)
      expect(account_info['number']).to eq account1.number
      expect(account_info['balance'].to_f).to eq account1.balance.to_f
    end

    it "should show status error when the account is not found" do
      post :balance, params: { account_number: '666666-6666' }
      expect(response).to have_http_status(:unprocessable_entity)

      status_info = JSON.parse(response.body)
      expect(status_info['status']).to eq 'error'
      expect(status_info['message']).to eq 'Account not found'
    end
  end
end
