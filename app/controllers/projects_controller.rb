class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    Github.new
  end
end
