class WelcomeController < LoggedUserController
  skip_load_and_authorize_resource

  def index

  end

end
