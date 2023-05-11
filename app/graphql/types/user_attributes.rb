class Types::UserAttributes < Types::BaseInputObject
  description 'Attributes for creating or updating a blog user'
  argument :name, String, "Name of the user", required: true
  argument :email, String, "Email of the user", required: false
end
