module CurrentGameConcern

  extend ActiveSupport::Concern

  included do

    class << self

      # thread-safe getter (as implemented in https://github.com/stffn/declarative_authorization)
      def current
        Thread.current[:current_game]
      end
      alias :current_game :current

      # thread-safe setter (as implemented in https://github.com/stffn/declarative_authorization)
      def current=(game)
        Thread.current[:current_game] = game
      end
      alias :current_game= :current=

    end

  end

end