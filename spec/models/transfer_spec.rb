require 'rails_helper'

RSpec.describe Transfer, type: :model do

  let(:source_account)      { FactoryBot.create(:account, number: '1234-5', opening_balance: 100.0) }
  let(:destination_account) { FactoryBot.create(:account, number: '0000-5', opening_balance: 100.0) }
  let(:default_user)        { FactoryBot.create(:user) }

  describe "necessary associations" do
    it { is_expected.to belong_to(:source_account).class_name("Account") }
    it { is_expected.to belong_to(:destination_account).class_name("Account") }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0.0) }

    describe "source account" do

      context "when source account does not enough balance" do
        subject { described_class.new(source_account_id: source_account.id, destination_account_id: destination_account.id, amount: 110.00, user_id: default_user.id) }

        it { is_expected.to be_invalid }
        it "with messages errors" do
          subject.valid?
          expect(subject.errors["source_account_id"]).to include("insufficient balance to transfer")
        end
      end

      context "when source account does enough balance" do
        subject { described_class.new(source_account_id: source_account.id, destination_account_id: destination_account.id, amount: 50.00, user_id: default_user.id) }

        it { is_expected.to be_valid }
        it "no messages errors" do
          subject.valid?
          expect(subject.errors).to be_empty
        end
      end
    end
  end

  describe "execute" do
    describe "with account numbers" do
      subject { described_class.new(source_account_number: source_account.number, destination_account_number: destination_account.number, amount: 20.00, user_id: default_user.id) }

      it "valids" do
        subject.execute
        expect(subject).to be_valid
        #expect(subject.errors["source_account_id"]).to include("insufficient balance to transfer")
      end
    end

    describe "without invalids accounts" do
      context "when source account number empty" do
        subject { described_class.new(source_account_number: nil, destination_account_number: destination_account.number, amount: 20.00, user_id: default_user.id) }

        it "source account invalid" do
          subject.execute
          expect(subject).to be_invalid
          expect(subject.errors["source_account"]).to include("must exist")
        end
      end

      context "when source account number does not exist" do
        subject { described_class.new(source_account_number: '666666666-6', destination_account_number: destination_account.number, amount: 20.00, user_id: default_user.id) }

        it "source account invalid" do
          subject.execute
          expect(subject).to be_invalid
          expect(subject.errors["source_account"]).to include("must exist")
        end
      end

      context "when source account number empty" do
        subject { described_class.new(source_account_number: source_account.number, destination_account_number: nil, amount: 20.00, user_id: default_user.id) }

        it "destination account invalid" do
          subject.execute
          expect(subject).to be_invalid
          expect(subject.errors["destination_account"]).to include("must exist")
        end
      end

      context "when source account number does not exist" do
        subject { described_class.new(source_account_number: source_account.number, destination_account_number: '666666666-6', amount: 20.00, user_id: default_user.id) }

        it "destination account invalid" do
          subject.execute
          expect(subject).to be_invalid
          expect(subject.errors["destination_account"]).to include("must exist")
        end
      end
    end
  end
end
