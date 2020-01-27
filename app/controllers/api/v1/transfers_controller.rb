module Api
	module V1
    class TransfersController < ApplicationController
      def create
        @transfer = Transfer.new(transfer_params.merge(user: current_user))
        if @transfer.execute
          render json: @transfer, status: :created
        else
          render json: @transfer.errors, status: :unprocessable_entity
        end
      end

      private
      def transfer_params
        params.permit(:source_account_number, :destination_account_number, :amount)
      end
    end
	end
end

