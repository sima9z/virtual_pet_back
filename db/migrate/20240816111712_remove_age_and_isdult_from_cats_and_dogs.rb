class RemoveAgeAndIsdultFromCatsAndDogs < ActiveRecord::Migration[7.0]
  def change
    remove_column :cats, :age, :integer
    remove_column :dogs, :age, :integer
    remove_column :cats, :is_adult, :boolean
    remove_column :dogs, :is_adult, :boolean
  end
end
