class AddMaxPhysicalToPets < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :max_physical, :integer, default: 50
    add_column :cats, :max_physical, :integer, default: 50
  end
end
