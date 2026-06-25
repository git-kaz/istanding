class ResetUserHpJob < ApplicationJob
  def perform(user_id)
    User.update_all(hp: 100)
  end
end
