class Account < ApplicationRecord

  validates :number, 
            presence: true, 
            uniqueness: true

  validates :opening_balance, 
            presence: true,
            numericality: { greater_than_or_equal_to: 0.0 }

  has_many :withdrawals, foreign_key: :source_account_id,      class_name: "Transfer"
  has_many :deposits,    foreign_key: :destination_account_id, class_name: "Transfer"

  def withdrawals_total
    withdrawals.sum(:amount)
  end

  def deposits_total
    deposits.sum(:amount)
  end

  def balance
    opening_balance + (deposits_total - withdrawals_total)
  end

end
