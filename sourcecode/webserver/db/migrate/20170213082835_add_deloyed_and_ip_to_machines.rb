class AddDeloyedAndIpToMachines < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :ip, :string
    add_column :machines, :deployed, :boolean
    add_index :machines, :ip, :unique => true
  end
end
