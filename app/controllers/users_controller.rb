class UsersController < LoggedUserController

  def edit

  end

  private

    def user_params
      params.fetch(:user, {}).permit(
        :email
      )
    end

end
