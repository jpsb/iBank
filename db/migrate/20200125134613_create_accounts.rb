class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :number
      t.decimal :opening_balance, default: 0.0 
      t.timestamps
    end
  end
end
