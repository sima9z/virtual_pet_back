class Cat < ApplicationRecord
  belongs_to :user

  def level_up_experience
    100 * level ** 1.5
  end

  def gain_experience(amount)
    self.experience += amount
    while self.experience >= level_up_experience
      self.experience -= level_up_experience
      self.level += 1
      check_adult_status
    end
    save
  end

  def check_adult_status
    self.is_adult = self.level >= 10
  end

  def update_state(hungry_amount, thirsty_amount)
    self.hungry = hungry_amount
    self.thirsty = thirsty_amount
    save
  end
end
