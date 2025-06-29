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
  params.require(:plan).permit(:date, :plan)
  end

  # 1週間分の予定を取得する
  def get_week
    wdays = ['日','月','火','水','木','金','土']

    # 今日の日付オブジェクト
    @todays_date = Date.today

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end


    # ・今日の曜日番号にオフセット x を足して……
      wday_num = @todays_date.wday + x
    # ・もし7以上なら7引いて戻す
      wday_num = wday_num - 7 if wday_num >= 7
    
      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, wdays: wdays[wday_num], plans: today_plans }
      @week_days.push(days)
    end
  end
end

