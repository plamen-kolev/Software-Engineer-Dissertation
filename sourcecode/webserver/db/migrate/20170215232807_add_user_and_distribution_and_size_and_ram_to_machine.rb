class AddUserAndDistributionAndSizeAndRamToMachine < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :vm_user, :string
    add_column :machines, :distribution, :string
    add_column :machines, :ports, :string
    add_column :machines, :packages, :string
    add_column :machines, :ram, :decimal
    add_column :machines, :last_alive, :boolean
    add_column :machines, :pem, :text
  end
end
