class AddLastUpdateAtToPets < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :last_update_at, :datetime
    add_column :cats, :last_update_at, :datetime
    add_column :dogs, :max_satiety, :integer, default: 100
    add_column :cats, :max_satiety, :integer, default: 100
    add_column :dogs, :max_happiness, :integer, default: 100
    add_column :cats, :max_happiness, :integer, default: 100
  end
end
