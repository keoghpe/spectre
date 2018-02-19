class BaselinesController < ApplicationController
  skip_before_filter :authenticate_user!

  def show
    @baseline = Baseline.where(key: params[:key]).first
    raise ActiveRecord::RecordNotFound if @baseline.nil?

    respond_to do |format|
      format.png {
        send_file @baseline.screenshot.path, type: 'image/png', disposition: 'inline'
      }
      format.json {
        render json: @baseline.to_json
      }
    end
  end
end
