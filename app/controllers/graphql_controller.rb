class GraphqlController < ApplicationController
  def execute
    skips_authorization = ['signinUser', 'createUser']
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    jwt_response = jwt_decode(request)

    if jwt_response[:status_code] == 200 
      id = jwt_response[:data][:id]
      current_user = User.find_by(id: id)
    end

    context = { current_user: current_user }
    query_parse = GraphQL::Query.new(GraphqlApiSchema, query_string = params[:query])
    result = GraphqlApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)

    if current_user.present? || skips_authorization.include?(query_parse.selected_operation.selections[0].name)
      render json: result
    else
      render json: { errors: [{ message: 'Login first'}], data: {} }, status: 500
    end
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end

  def jwt_decode(request)
    data = JWT.decode(request.headers['Authorization'], Rails.application.credentials.secret_key_base).first
    { data: HashWithIndifferentAccess.new(data), status_code: 200 }
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    { status_code: 400, errors: e.message }
  rescue JWT::DecodeError => e
    { status_code: 400, errors: e.message }
  end
end
