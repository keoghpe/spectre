class AddAccessTokenToRun < ActiveRecord::Migration
  def change
    add_column :runs, :access_token, :string
  end
end
