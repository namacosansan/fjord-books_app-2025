# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_own_report, only: %i[edit update destroy]

  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @comments = @report.comments.order(created_at: :desc)
  end

  def new
    @report = Report.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy!
    redirect_to reports_path, status: :see_other, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_own_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.expect(report: %i[reported_on title body])
  end
end
