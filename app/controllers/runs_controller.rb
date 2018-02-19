class RunsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_filter :authenticate_user!, only: [:show, :create]

  def show
    project = Project.find_by_slug!(params[:project_slug])
    suite = project.suites.find_by_slug!(params[:suite_slug])
    @run = suite.runs.find_by_sequential_id!(params[:sequential_id])
    @test_filters = TestFilters.new(@run.tests, true, params)

    respond_to do |format|
      format.html
      format.json {
        render json: @run.to_json(:include => :tests)
      }
    end
  end

  def new
    @run = Run.new
  end

  def create
    project = Project.find_or_create_by(name: params[:project])
    suite = project.suites.find_or_create_by(name: params[:suite])
    # add commit sha, add number of screenshots, post to github
    @run = suite.runs.create(sha: params[:sha], screenshot_count: params[:screenshot_count])
    if params[:sha].present?
      GithubStatusClient.new.post_status(
          @run,
          state: 'pending',
          target_url: project_suite_run_url(@run.suite.project, @run.suite, @run),
          description: 'Processing Screenshots',
          context: 'kubicle_visual_ci'
      )
    end
    render :json => @run.to_json
  end
end
