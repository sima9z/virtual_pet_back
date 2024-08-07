class Cat < ApplicationRecord
  belongs_to :user

  validates :physical, :satiety, :happiness, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

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
    self.states = { hungry: hungry_amount, thirsty: thirsty_amount }.to_json
    save
  end

  def hungry
    states['hungry']
  end

  def thirsty
    states['thirsty']
  end
end
