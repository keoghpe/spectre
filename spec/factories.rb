include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user do
    
  end
  factory :project do
    name 'spec_project'
    slug 'spec_project_slug'
  end

  factory :suite do
    name 'spec_suite'
    slug 'spec_suite_slug'
    project
    factory :baseline_suite do
      after(:create) do |suite|
        project = suite.project
        project.baseline_suite = suite
        project.save!
      end
    end
  end

  factory :run do
    suite
  end

  factory :test do
    name 'rspec_test'
    browser 'na'
    size '0'
    screenshot { fixture_file_upload(Rails.root.join(*%w[ spec support images testcard.jpg ]), 'image/jpg') }
    run
  end
end
