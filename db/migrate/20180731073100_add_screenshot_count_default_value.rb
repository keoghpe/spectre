class AddScreenshotCountDefaultValue < ActiveRecord::Migration
  def change
    change_column_default :runs, :screenshot_count, 0
  end
end
