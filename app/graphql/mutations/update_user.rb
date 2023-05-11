module Mutations
  class UpdateUser < BaseMutation
    field :user, Types::UserType, null: false

    argument :id, ID, required: true
    argument :attributes, Types::UserAttributes, required: true

    def resolve(id:, attributes:)
      user = User.find_by(id: id)
      raise GraphQL::ExecutionError, "Error" unless user.present?
      if user.update(attributes.to_h)
        { user: user }
      else
        raise GraphQL::ExecutionError, user.errors.full_messages.join(", ")
      end
    end
  end
end
