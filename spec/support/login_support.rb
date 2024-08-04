# frozen_string_literal: true

module LoginSupport
  def login_as(user)
    OmniAuth.config.mock_auth[:github] =
      OmniAuth::AuthHash.new({ provider: 'github', uid: user.id, info: { nickname: user.login, name: user.name, image: user.avatar_url } })
    visit root_path
    click_button 'ログイン'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
