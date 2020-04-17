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
    other_size = searches.size * 0.25
    groups_all = searches.group("JSON_UNQUOTE(properties -> '$.dept_long')").count.sort_by { |dept, num| num }
    groups_new = { "Other" => 0 }

    groups_all.each do |e|
      if e[1] > other_size || groups_new["Other"] > other_size
        groups_new[e[0]] = e[1]
      else
        groups_new["Other"] += e[1]
      end
    end

    render json: groups_new
  end

  def searches_volume
    render json: Ahoy::Event.where(name: "Course search").group_by_day(:time, range: 1.months.ago..Time.now).count
  end

  def visitor_location
    render json: Ahoy::Visit.group(:region).count
  end

  def referrals
    render json: Ahoy::Visit.where("referring_domain IS NOT NULL").group(:referring_domain).count.sort_by { |d, n| n }.reverse
  end

  private

  def signed_in_user
    redirect_to signin_path, notice: "Please sign in." unless signed_in?
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
