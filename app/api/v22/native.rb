module V22
  class Native < Grape::API
    prefix :api
    version %(v22), using: :path

    format :json
    default_format :json

    formatter :json, Grape::Formatter::Jbuilder

    resource :native do
      get :auth do
        user = User.find_for_authentication(login: params[:login])

        if user && user.valid_password?(params[:password])
          key = ApiKey.exists?(user_id: user.id) ? ApiKey.find_by(user_id: user.id) : ApiKey.create(user_id: user.id)
          key.reset if key.expired?
          { token: key.access_token }
        else
          error!('Unauthorized.', 401)
        end
      end

      get :scores do
        user = authenticate!
        { result: [Sheet.all, user.scores] }
      end
    end

    helpers do
      def authenticate!
        error!('Unauthorized. Invalid or expired token.', 401) unless current_user
        current_user
      end

      def current_user
        token = ApiKey.find_by(access_token: params[:token])
        if token && !token.expired?
          @current_user = User.find(token.user_id)
        else
          false
        end
      end
    end
  end
end
