class AddAccessTokenExpiresToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :access_token_expires, :datetime
  end
end
