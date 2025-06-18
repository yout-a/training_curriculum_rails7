class CalendarsController < ApplicationController
  # 1週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:calendars).permit(:date, :plan)
  end

  # 1週間分の予定を取得する
  def get_week
    wdays = ['日','月','火','水','木','金','土']

    # 今日の日付オブジェクト
    @todays_date = Date.today

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = plans.select { |plan| plan.date == @todays_date + x }
                         .map(&:plan)
      days = {
        month: (@todays_date + x).month,
        date:  (@todays_date + x).day,
        plans: today_plans
      }
      @week_days << days
    end
  end
end

