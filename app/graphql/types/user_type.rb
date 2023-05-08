# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String
    field :name, String
    field :text, String
    field :description, String
    field :posts, [Types::PostType]
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def text
      "#{object.text}"
    end
  end
end
