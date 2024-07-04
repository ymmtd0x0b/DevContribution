# frozen_string_literal: true

require 'omniauth'
OmniAuth.config.test_mode = true

def visit_with_onmiauth(path:, user:)
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({ provider: 'github',
                                                                uid: user.id,
                                                                info: { nickname: user.login,
                                                                        name: user.name,
                                                                        image: user.avatar_url } })
  visit root_path
  click_button 'ログイン'
  visit path
end
