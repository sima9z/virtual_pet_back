class AddPlayCountAndLastPlayedAtToDogsAndCats < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :play_count, :integer, default: 0, null: false
    add_column :dogs, :last_played_at, :datetime
    add_column :cats, :play_count, :integer, default: 0, null: false
    add_column :cats, :last_played_at, :datetime
  end
end
