class CreateMachines < ActiveRecord::Migration[5.0]
  def change
    create_table :machines do |t|
      t.string :title, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :machines, :title, unique: true
  end
end
