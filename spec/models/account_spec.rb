require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "necessary associations" do
    it { is_expected.to have_many(:withdrawals).class_name("Transfer").with_foreign_key(:source_account_id) }
    it { is_expected.to have_many(:deposits).class_name("Transfer").with_foreign_key(:destination_account_id) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_uniqueness_of(:number) }
    it { is_expected.to validate_presence_of(:opening_balance) }
    it { is_expected.to validate_numericality_of(:opening_balance).is_greater_than_or_equal_to(0.0) }
  end

  describe "bank operations" do
    let(:source_account)      { FactoryBot.create(:account, number: '1234-5', opening_balance: 100.0) }
    let(:destination_account) { FactoryBot.create(:account, number: '0000-5', opening_balance: 100.0) }
    let(:default_user)        { FactoryBot.create(:user) }

    let!(:transfer1) { FactoryBot.create(:transfer, source_account: source_account, destination_account: destination_account, amount: 10.00, user: default_user) }
    let!(:transfer2) { FactoryBot.create(:transfer, source_account: source_account, destination_account: destination_account, amount: 20.00, user: default_user) }
    let!(:transfer3) { FactoryBot.create(:transfer, source_account: source_account, destination_account: destination_account, amount: 30.00, user: default_user) }

    it "sums all operations" do
      expect(source_account.withdrawals_total).to eql(60.0)
      expect(destination_account.deposits_total).to eql(60.0)

      expect(source_account.balance).to eql(40.0)
      expect(destination_account.balance).to eql(160.0)
    end
  end
end
