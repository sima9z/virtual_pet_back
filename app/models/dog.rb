class Dog < ApplicationRecord
  belongs_to :user

  validates :physical, :satiety, :happiness, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def level_up_experience
    100 * level ** 1.5
  end

  def gain_experience(amount)
    self.experience += amount
    previous_level = self.level
  
    # レベルアップの条件を確認し、必要に応じてレベルを上げる
    if self.experience >= level_up_experience
      self.experience -= level_up_experience
      self.level += 1
    end
  
    # レベル3に初めて達したときにのみ breeding を実行
    if previous_level < 3 && self.level >= 3 && !self.bred_at_level_3
      breeding
      self.bred_at_level_3 = true
    end
  
    save
  end

  def breeding
    self.offspring_count += 1 # 繁殖回数を増やす
    save
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

  def max_physical
    50
  end
end
