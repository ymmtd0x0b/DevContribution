# frozen_string_literal: true

module Sweeper
  class Wiki
    def call(user)
      user.wikis.destroy_all
    end
  end
end
