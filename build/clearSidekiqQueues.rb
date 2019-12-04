require 'sidekiq/api'

# 1. Clear retry set

Sidekiq::RetrySet.new.clear

# 2. Clear scheduled jobs 

Sidekiq::ScheduledSet.new.clear

# 3. Clear 'Processed' and 'Failed' jobs

Sidekiq::Stats.new.reset

# 3. Clear 'Dead' jobs statistics

Sidekiq::DeadSet.new.clear

# Via API

stats = Sidekiq::Stats.new
stats.queues

queue = Sidekiq::Queue.new('default')
queue.count
queue.clear

queue = Sidekiq::Queue.new('ingest')
queue.count
queue.clear
