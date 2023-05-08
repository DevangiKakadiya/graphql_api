module Mutations
  class DestroyUser < BaseMutation
    field :text, String, null: false

    argument :id, ID, required: true

    def resolve(id:)
      user = User.find_by(id: id)
      if user.present?
        user&.destroy
        text = 'User deleted successfully'
      else
        text = 'User Not found'
      end
        { text: text }
    end
  end
end

