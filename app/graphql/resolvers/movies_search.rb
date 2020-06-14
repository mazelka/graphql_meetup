# frozen_string_literal: true

module Resolvers
  class MoviesSearch < AuthBase
    type Types::Connections::MovieConnection, null: false

    argument :filter, String, required: false

    def resolve(filter: nil)
      match_operation ::Movie::Operation::Index.call(
        params: filter,
        current_user: current_user
      )
    end
  end
end
