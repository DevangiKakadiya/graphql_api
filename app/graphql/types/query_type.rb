module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :users, [Types::UserType], null: false

    def users
      User.left_joins(:posts).select("users.*, CONCAT(users.id, ' - ', users.name) AS text, string_agg(posts.description, ', ') description").group('users.id')
    end

    field :posts, [Types::PostType], null: false

    def posts
      Post.all
    end

    field :user, UserType, 'Find a User by ID' do
      argument :id, ID
    end

    def user(id:)
      User.find(id)
    end
  end
end
