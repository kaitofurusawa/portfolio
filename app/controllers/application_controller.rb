class ApplicationController < ActionController::Base
  include Sorcery::Controller

  allow_browser versions: :modern
end
