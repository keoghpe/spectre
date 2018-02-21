class AddBaselineSuiteToProject < ActiveRecord::Migration
  def change
    add_reference :projects, :baseline_suite, index: true
  end
end
