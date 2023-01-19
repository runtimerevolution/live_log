# frozen_string_literal: true

module AuthHelper
  def headers(_options = {})
    user = ENV['LIVELOG_USERNAME']
    pw = ENV['LIVELOG_PASSWORD']

    { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(user, pw) }
  end

  def auth_get(route, params = {})
    get route, params: params[:params], headers: headers
  end

  def auth_post(route, params = {})
    post route, params: params[:params], headers: headers
  end
end
