class CreateDogs < ActiveRecord::Migration[7.0]
  def change
    create_table :dogs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :breed, null: false
      t.integer :age, default: 0, null: false
      t.integer :experience, default: 0, null: false
      t.integer :level, default: 1, null: false
      t.integer :states , default: 0, null: false
      t.boolean :is_adult, default: false, null: false

      t.timestamps
    end
  end
end
