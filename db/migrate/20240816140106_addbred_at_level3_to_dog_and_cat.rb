class AddbredAtLevel3ToDogAndCat < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :bred_at_level_3, :boolean, default: false
    add_column :cats, :bred_at_level_3, :boolean, default: false
  end
end
