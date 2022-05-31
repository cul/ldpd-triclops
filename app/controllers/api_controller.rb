class ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render json: errors('Not Found'), status: :not_found
  end

  private

    # Returns 406 status if format requested is not json. This method can be
    # used as a before_action callback for any controllers that only respond
    # to json.
    def ensure_json_request
      return if request.format.blank? || request.format == :json
      head :not_acceptable
    end

    # Generates JSON with errors
    #
    # @param String|Array json response describing errors
    def errors(errors)
      { errors: Array.wrap(errors).map { |e| { title: e } } }
    end
end
