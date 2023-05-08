class Mutations::CreateUser < Mutations::BaseMutation
  argument :name, String, required: true
  argument :email, String, required: true

  field :user, Types::UserType, null: false
  field :errors, [String], null: false

  def resolve(name:, email:)
    begin
      user = User.new(name: name.presence || '', email: email)
      user.save!
      user
    rescue ActiveRecord::RecordInvalid => err
      GraphQL::ExecutionError.new(user.errors.messages)
    end
    # user = User.new(name: name.presence || '', email: email)
    # if user.save
    #   {
    #     user: user,
    #     errors: [],
    #   }
    # else
    #   {
    #     errors: user.errors.full_messages
    #   }
    # end
  end
end
