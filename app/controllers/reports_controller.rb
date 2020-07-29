class ReportsController < ApplicationController
  before_action :get_reportable, only: %i[create edit update new]
  before_action :signed_in_user, only: %i[create edit update new]
  before_action :admin_user, only: %i[edit update index]

  def index
    @resolved = []
    @unresolved = []
    Report.all.each do |report|
      if report.resolved
        @resolved << report
      else
        @unresolved << report
      end
    end
  end

  def create
    @report = Report.build_report(@reportable, @user, params[:report][:title], params[:report][:body])
    # send email
    @message = ''
    if @report.duplicate?
      @message = 'Cannot file a report more than once'
    elsif @report.save
      @message = case @reportable.class.to_s.underscore
                 when 'handle'
                   "You have filed a report against #{@reportable.username}"
                 when 'user'
                   "You have filed a report against #{@reportable.fname} #{@reportable.lname}"
                 when 'comment'
                   "You have filed a report against a comment by #{@reportable.handle}"
                 else
                   'You have filed a report'
                 end
      Interact.report_confirmation(@user, @report).deliver
      Interact.admin_report_notice(@user, @report).deliver
    else
      @message = 'Something went wrong'
    end
    @message
    respond_to do |format|
      format.js
    end
  end

  def edit
    @report = Report.find(params[:id])
    @reportable_changed = @reportable.updated_at > @report.created_at
    @report.lock("#{@user.fname} #{@user.lname}")
    @report.save
    @to_comp = params[:to_comp] if params[:to_comp]
    @to_viol = params[:to_viol] if params[:to_viol]
    @response = params[:response] if params[:response]
    @message = params[:message] if params[:message]
    logger.debug @message
  end

  def update
    @report = Report.find(params[:id])
    if params[:resolved] && params[:to_comp].blank?
      redirect_to edit_report_path(@report.reportable_type.underscore, @report.reportable_id, @report.user_id, @report.id, response: params[:response], to_viol: params[:to_viol], message: 'Cannot resolve report without informing reporter.')
    end

    @report.unlock
    response = params[:response]
    if params[:to_comp]
      response << "\n\nMessage to Complainant:\n#{params[:to_comp]}"
      Interact.to_reporter(User.find(@report.user_id), params[:to_comp], @report).deliver
    end
    if params[:to_viol]
      response << "\n\nMessage to Violator:\n#{params[:to_viol]}"
      Interact.to_reported(@report.reported, params[:to_viol], @report).deliver
    end
    if params[:resolved]
      @report.resolve(current_user, response)
    else
      @report.unresolve(current_user, response)
    end
    @report.save
  end

  def new
    @report = Report.new
    @report.reportable_id = @reportable.id
    @report.reportable_type = @reportable.class.base_class.name
  end

  private

  def get_reportable
    @reportable = params[:reportable_type].camelize.constantize.find(params[:reportable_id])
  end

  def admin_user
    redirect_to sign_in_path unless current_user.admin?
  end

  def signed_in_user
    @user = User.find(params[:user_id]) if params[:user_id]
    redirect_to sign_in_path unless @user
  end
end
