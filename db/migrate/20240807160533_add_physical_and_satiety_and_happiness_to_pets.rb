class AddPhysicalAndSatietyAndHappinessToPets < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :physical, :integer, default: 30
    add_column :dogs, :satiety, :integer, default: 20
    add_column :dogs, :happiness, :integer, default: 20
    add_column :cats, :physical, :integer, default: 30
    add_column :cats, :satiety, :integer, default: 20
    add_column :cats, :happiness, :integer, default: 20
  end
end
