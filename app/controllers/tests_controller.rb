require 'image_processor'

class TestsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_filter :authenticate_user!, only: [:create]

  def new
    @test = Test.new
  end

  def update
    @test = Test.find(params[:id])
    if params[:test][:baseline] == 'true'
      @test.pass = true
      @test.save
      update_github_status
      redirect_to project_suite_run_url(@test.run.suite.project, @test.run.suite, @test.run)
    end
  end

  def create
    ImageProcessor.crop(test_params[:screenshot].path, test_params[:crop_area]) if test_params[:crop_area]
    @test = Test.create!(test_params)
    ScreenshotComparison.new(@test, test_params[:screenshot])
    update_github_status
    render json: @test.to_json
  end

  private

  def test_params
    params.require(:test).permit(:name, :browser, :size, :screenshot, :run_id, :source_url, :fuzz_level, :highlight_colour, :crop_area)
  end

  def update_github_status
    if @test.run.sha.present?
      if @test.run.passed?
        GithubStatusClient.new.post_status(
            @test.run,
            state: 'success',
            target_url: project_suite_run_url(@test.run.suite.project, @test.run.suite, @test.run),
            description: 'Screenshots look good!',
            context: 'kubicle_visual_ci'
        )
      elsif @test.run.failed?
        GithubStatusClient.new.post_status(
            @test.run,
            state: 'failure',
            target_url: project_suite_run_url(@test.run.suite.project, @test.run.suite, @test.run),
            description: 'Differences detected with baseline.',
            context: 'kubicle_visual_ci'
        )
      end
    end
  end
end
