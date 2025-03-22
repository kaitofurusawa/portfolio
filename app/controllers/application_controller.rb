class ApplicationController < ActionController::Base
  include Sorcery::Controller  # ← これ追加！

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
