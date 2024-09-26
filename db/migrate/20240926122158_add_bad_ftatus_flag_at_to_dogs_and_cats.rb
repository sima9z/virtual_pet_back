class AddBadFtatusFlagAtToDogsAndCats < ActiveRecord::Migration[7.0]
  def change
    add_column :dogs, :bad_status_flag, :boolean, default: false, null: false
    add_column :cats, :bad_status_flag, :boolean, default: false, null: false
  end
end
