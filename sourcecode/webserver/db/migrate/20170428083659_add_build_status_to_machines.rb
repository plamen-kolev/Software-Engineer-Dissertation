class AddBuildStatusToMachines < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :build_status, :string
  end
end
