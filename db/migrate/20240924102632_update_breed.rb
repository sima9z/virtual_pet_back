class UpdateBreed < ActiveRecord::Migration[7.0]
  def up
    # タイプ1をダックスフンドに変更
    Dog.where(breed: 'タイプ1').update_all(breed: 'ダックスフンド')
    Cat.where(breed: 'タイプ1').update_all(breed: '三毛猫')
  end

  def down
    # 変更を元に戻す場合
    Dog.where(breed: 'ダックスフンド').update_all(breed: 'タイプ1')
    Dog.where(breed: '三毛猫').update_all(breed: 'タイプ1')
  end
end
