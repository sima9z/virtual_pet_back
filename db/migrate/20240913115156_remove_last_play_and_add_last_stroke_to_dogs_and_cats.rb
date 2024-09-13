class RemoveLastPlayAndAddLastStrokeToDogsAndCats < ActiveRecord::Migration[7.0]
  def change
    # last_update_atカラムを削除
    remove_column :dogs, :last_play_at, :datetime
    remove_column :cats, :last_play_at, :datetime
    
    # 新しいカラムを追加
    add_column :dogs, :last_stroke_at, :datetime
    add_column :cats, :last_stroke_at, :datetime
  end
end
