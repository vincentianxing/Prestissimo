class SettingsController < ApplicationController

  def change
    @high_comment_score = Setting.get_val('high_comment_score')
    @low_comment_score = Setting.get_val('low_comment_score')
    @comment_report_threshold = Setting.get_val('comment_report_threshold')
    @handle_report_threshold = Setting.get_val('handle_report_threshold')
    @user_report_threshold = Setting.get_val('user_report_threshold')
    @handle_abuse_threshold = Setting.get_val('handle_abuse_threshold')
    #	sems = Setting.get_value('semesters')
    #	@settings[:semesters] = ''
    #	sems.split('|').each do |sem|
    #		@settings[:semesters] << sem + ' '
    #	end
    #	@settings[:semesters].slice!
    #	@settings[:admins] = ''
    #	admins = Setting.get_value('admins')
    #	admins.split('|').each do |admin|
    #		@settings[:admins] << admin + ' '
    #	end
    #	@settings[:admins].slice!
  end

  def update_all
    @settings = {}
    @settings[:high_comment_score] = Setting.set('high_comment_score',params[:high_comment_score]).value if params[:high_comment_score]
    @settings[:low_comment_score] = Setting.set('low_comment_score',params[:low_comment_score]).value if params[:low_comment_score]
    @settings[:comment_report_threshold] = Setting.set('comment_report_threshold',params[:comment_report_threshold]).value if params[:comment_report_threshold]
    @settings[:handle_report_threshold] = Setting.set('handle_report_threshold',params[:handle_report_threshold]).value if params[:handle_report_threshold]
    @settings[:user_report_threshold] = Setting.set('user_report_threshold',params[:user_report_threshold]).value if params[:user_report_threshold]
    @settings[:handle_abuse_threshold] = Setting.set('handle_abuse_threshold',params[:handle_abuse_threshold]).value if params[:handle_abuse_threshold]
    if !params[:add_admin].blank?
      name = params[:add_admin].split(' ')
      user = User.where("fname = ? AND lname = ?", name[0], name[1]).first
      if user.make_admin
	admins = Setting.get_val('admins') + '|' + params[:add_admin]
	@settings[:admins] = Setting.set('admins',admins).value
      end
    end
    if !params[:rem_admin].blank?
      name = params[:rem_admin].split(' ')
      user = User.where("fname = ? AND lname = ?", name[0], name[1]).first
      if user.unmake_admin
	admins = Setting.get_val('admins').gsub("|#{params[:rem_admin]}","").gsub("#{params[:rem_admin]}|","")
	  @settings[:admins] = Setting.set('admins',admins).value
      end
    else
      @settings[:admins] = Setting.get_val('admins')
    end
    @settings
  end

  def edit_motd
    @motd = Setting.get_val('motd')
  end

  def set_motd
    @motd = Setting.set('motd',params[:motd]).value if params[:motd]
  end
end
