class TransferSerializer < ActiveModel::Serializer
  attributes :id, :amount
  
  attribute :user_transfer do
    object.user.email
  end

  attribute :source_account_number do
    object.source_account.number  
  end

  attribute :destination_account_number do
    object.destination_account.number  
  end

end
