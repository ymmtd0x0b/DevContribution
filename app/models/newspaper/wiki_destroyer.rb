# frozen_string_literal: true

module Newspaper
  class WikiDestroyer
    def call(user)
      user.wikis.destroy_all
    end
  end
end
