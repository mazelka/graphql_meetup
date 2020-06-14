# frozen_string_literal: true

module Resolvers
  class Me < AuthBase
    type Types::UserAccountType, null: false

    argument :order_by, Types::Inputs::MovieOrderingInput, required: false

    def resolve(order_by: nil)
      order_by.to_h
      current_user
    end
  end
end
