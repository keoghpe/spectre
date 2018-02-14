class AddScreenShotCountAndShaToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :sha, :string
    add_column :runs, :screenshot_count, :integer
  end
end
