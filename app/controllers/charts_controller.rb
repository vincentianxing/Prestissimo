class ChartsController < AplicationController
  def new_users_chart
    render json: line_chart User.group_by_day(:created_at, range: 1.months.ago..Time.now).count
  end
end
