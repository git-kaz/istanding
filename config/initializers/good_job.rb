Rails.application.configure do
  config.good_job.execution_mode = :async
  config.good_job.queues = "default"
  config.good_job.max_threads = 2
  config.good_job.poll_interval = 30

  config.good_job.enable_cron = true
  config.good_job.cron = {
    "reset_user_hp" => {
      cron: "0 2 * * *", # 毎日2時に実行
      class: "ResetUserHpJob"
    }
  }
end