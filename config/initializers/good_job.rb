Rails.application.configure do
  config.good_job.execution_mode = :async
  config.good_job.queues = "default"
  config.good_job.max_threads = 2
  config.good_job.poll_interval = 30
end