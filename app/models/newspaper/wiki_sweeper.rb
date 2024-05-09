# frozen_string_literal: true

module Newspaper
  class WikiSweeper
    def call(user)
      user.wikis.destroy_all
    end
  end
end
