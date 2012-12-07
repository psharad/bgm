class UserSession < Authlogic::Session::Base
  def remember_me_for
    365.days
  end
end