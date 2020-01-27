class Transfer < ApplicationRecord

  belongs_to :source_account, class_name: "Account"
  belongs_to :destination_account, class_name: "Account"
  attr_accessor :source_account_number, :destination_account_number
  belongs_to :user

  validates :amount, 
            presence: true,
            numericality: { greater_than: 0.0 }

  validate :source_account_limit, unless: Proc.new { |t| t.source_account_id.blank? }

  def execute 
    self.source_account = Account.where(number: source_account_number).first 
    self.destination_account = Account.where(number: destination_account_number).first
    self.save
  end

  private
  def source_account_limit
    return if (source_account.balance - amount) >= 0.0
    errors.add(:source_account_id, "insufficient balance to transfer")
  end

end
