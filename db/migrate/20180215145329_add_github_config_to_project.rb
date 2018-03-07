class AddGithubConfigToProject < ActiveRecord::Migration
  def change
    add_column :projects, :github_repo, :string
  end
end
