class LoggedPlayerController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_player!

end
