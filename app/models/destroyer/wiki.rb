# frozen_string_literal: true

module Destroyer
  class Wiki
    def call(user)
      user.wikis.destroy_all
    end
  end
end
