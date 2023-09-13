class Admin::MailerController < ApplicationController
  def send_summary_mail
    # ここでメール送信のロジックを呼び出す
    ArticleMailer.report_summary.deliver_now
    redirect_to admin_dashboard_path, notice: 'Summary mail sent.'
  end
end
