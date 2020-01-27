module Api
	module V1
    class AccountsController < ApplicationController
      def create
        @account = Account.new(account_params)
        if @account.save
          render json: @account, status: :created
        else
          render json: @account.errors, status: :unprocessable_entity
        end
      end

      def balance
        @account = Account.find_by_number(params[:account_number])
        if @account
          render json: @account, status: :ok
		    else
			    render json: {status: 'error', message:'Account not found'}, status: :unprocessable_entity
		    end
      end

      private
      def account_params
        params.permit(:number, :opening_balance)
      end
    end
	end
end




