class AddOffspringCountToDogAndCat < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :offspring_count, :integer, default: 0
    add_column :cats, :offspring_count, :integer, default: 0
  end
end
