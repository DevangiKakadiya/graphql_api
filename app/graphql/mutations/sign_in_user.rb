module Mutations
  class SignInUser < BaseMutation
    null true

    argument :credentials, Types::AuthProviderCredentialsInput, required: false

    field :token, String, null: true
    field :user, Types::UserType, null: true
    field :error, String, null: true

    def resolve(credentials: nil)
      return unless credentials

      user = User.find_by email: credentials[:email]
      if user
        if user.password == credentials[:password]
          token = JWT.encode({ id: user.id}, Rails.application.credentials.secret_key_base)
          { user: user, token: token, error: '' }
        else
          { token: '', error: 'Is invalid password' } 
        end
      else
        { token: '', error: 'Is invalid email' } 
      end
    end
  end
end
