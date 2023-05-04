module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :users, [Types::UserType], null: false

    def users
      User.all
    end

    field :user, UserType, 'Find a User by ID' do
      argument :id, ID
    end

    def user(id:)
      User.find(id)
    end
  end
end
