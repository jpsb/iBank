class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.decimal :amount
      t.integer :source_account_id
      t.integer :destination_account_id
      t.integer :user_id
      t.timestamps
    end
  end
end
