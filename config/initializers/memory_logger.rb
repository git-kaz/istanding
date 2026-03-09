if Rails.env.production?
  Thread.new do
    loop do
      memory_mb = `cat /proc/self/status | grep VmRSS`.match(/(\d+)/)[1].to_i / 1024
      Rails.logger.info "[MemoryMonitor] RSS: #{memory_mb} MB"
      sleep 60 # 1分ごとに出力
    end
  end
end
