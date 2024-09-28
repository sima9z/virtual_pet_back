class Cat < ApplicationRecord
  belongs_to :user

  validates :physical, :satiety, :happiness, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  COOLDOWN_TIME = 60.minutes

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
  
    # レベルが3の倍数に到達した場合、繁殖フラグをリセット
    if self.level % 3 != 0
      self.bred_at_level_3 = false
    end
  
    # レベル3の倍数に初めて達したときのみ繁殖を実行
    if self.level % 3 == 0 && !self.bred_at_level_3
      breeding
    end
  
    save
  end

  def breeding
    self.offspring_count += 1 # 繁殖回数を増やす
    self.bred_at_level_3 = true # フラグをここで設定
    save
  end

  def update_states
    # 空腹状態をチェック (満腹度が10以下なら空腹フラグ)
    if self.satiety <= 10
      self.states |= 1  # 空腹フラグを立てる
      self.bad_status_flag = true
    else
      self.states &= ~1 # 空腹フラグを解除
    end
  
    # 不機嫌状態をチェック (幸福度が20以下なら不機嫌フラグ)
    if self.happiness <= 10
      self.states |= 2  # 不機嫌フラグを立てる
      self.bad_status_flag = true
    else
      self.states &= ~2 # 不機嫌フラグを解除
    end
  end

  def can_feed?
    last_feed_at.nil? || last_feed_at < COOLDOWN_TIME.ago
  end

  def can_stroke?
    last_stroke_at.nil? || last_stroke_at < COOLDOWN_TIME.ago
  end

end
