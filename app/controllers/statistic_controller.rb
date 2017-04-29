class StatisticController < LoggedUserController

  # def create
  #
  # end

  # def edit
  #
  # end

  private

    def statistic_params
      params.fetch(:statistic, {}).permit(
      )
    end

end
