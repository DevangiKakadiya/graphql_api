class Mutations::CreateUser < Mutations::BaseMutation
  argument :name, String, required: true
  argument :credentials, Types::AuthProviderCredentialsInput, required: true

  type Types::UserType

  def resolve(name: nil, credentials: nil)
    begin
      user = User.new(
              name: name,
              email: credentials&.[](:email),
              password: credentials&.[](:password)
            )
      user.save!
      user
    rescue ActiveRecord::RecordInvalid => err
      GraphQL::ExecutionError.new(user.errors.messages)
    end
  end
end
