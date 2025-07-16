module LoginMacros
  def login_as(user)
    visit login_path
    within('.login-form-container') do
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password"
      click_button "ログイン"
    end
    visit user_path(user)
    # Sorceryでログイン判定の何かが表示されていればOK（たとえばユーザー名など）
    expect(page).to have_content(user.name)
  end
  

  def logout
    if page.has_link?('ログアウト')
      click_link 'ログアウト'
    end
  end
end

RSpec.configure do |config|
  config.include LoginMacros, type: :system
end
