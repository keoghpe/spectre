require 'rails_helper'

RSpec.describe ScreenshotComparison do
  same_image = ActionDispatch::Http::UploadedFile.new(tempfile: File.new("#{Rails.root}/spec/support/images/testcard.jpg"), filename: 'testcard.jpg')
  different_image = ActionDispatch::Http::UploadedFile.new(tempfile: File.new("#{Rails.root}/spec/support/images/testcard_large.jpg"), filename: 'testcard_large.jpg')

  let!(:project) { FactoryGirl.create(:project, name: 'proj1') }
  let!(:baseline_suite) { FactoryGirl.create(:baseline_suite, name: 'baseline suite', slug: 'baseline_suite_slug', project: project) }
  let!(:baseline_run) { FactoryGirl.create(:run, suite: baseline_suite) }
  let!(:new_suite) { FactoryGirl.create(:suite, name: '2nd suite', slug: '2nd_suite_slug', project: project) }
  let!(:new_run) { FactoryGirl.create(:run, suite: new_suite) }

  it 'should pass a test that is the same as it\'s baseline' do
    same_screenshot_comparison = ScreenshotComparison.new(
        FactoryGirl.create(:test, run: baseline_run, screenshot: same_image),
        same_image
    )
    expect(same_screenshot_comparison.pass).to eq true
  end

  it 'should automatically pass if it is the project baseline' do
    different_screenshot_comparison = ScreenshotComparison.new(
        FactoryGirl.create(:test, run: baseline_run, screenshot: same_image),
        different_image
    )
    expect(different_screenshot_comparison.pass).to eq true
  end

  it 'should fail a test that is different to it\'s project\'s baseline' do
    different_suite_comparison = ScreenshotComparison.new(
        FactoryGirl.create(:test, run: new_run, screenshot: same_image),
        different_image
    )
    expect(different_suite_comparison.pass).to eq false
  end

end
