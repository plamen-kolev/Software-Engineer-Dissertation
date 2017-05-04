class AddBuildStageToMachine < ActiveRecord::Migration[5.0]
  def change
    add_column :machines, :build_stage, :number, default: 0
  end
end
