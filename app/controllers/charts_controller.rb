class ChartsController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user

  def new_users
    render json: User.group_by_day(:created_at, range: 1.months.ago..Time.now).count
  end

  def site_visits
    render json: Ahoy::Visit.group_by_day(:started_at, range: 1.months.ago..Time.now).count
  end

  def searches_dept
    searches = Ahoy::Event.where(name: "Course search")
    cutoff_size = searches.size * 0.05
    groups_all = searches.group("JSON_UNQUOTE(properties -> '$.dept_long')").count
    groups_new = { "Other" => 0 }

    groups_all.each do |e|
      if e[1] > cutoff_size
        groups_new[e[0]] = e[1]
      else
        groups_new["Other"] += 1
      end
    end

    render json: groups_new
  end

  def searches_volume
    render json: Ahoy::Event.where(name: "Course search").group_by_day(:time, range: 1.months.ago..Time.now).count
  end

  private

  def signed_in_user
    redirect_to signin_path, notice: "Please sign in." unless signed_in?
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
