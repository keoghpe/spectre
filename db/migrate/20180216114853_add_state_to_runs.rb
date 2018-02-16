class AddStateToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :state, :string
  end
end
