module Ricer::Plugin::Stats
  class Perf < Ricer::Plug::Trigger
    
    include ActionView::Helpers::NumberHelper
     
    def execute
      bot.memory_peak
      queries = ActiveRecord::ConnectionAdapters::AbstractAdapter.querycount
      rply :perf,
        uptime: bot.display_uptime,
        queries: queries, qps: number_with_precision(queries/bot.uptime, :precision => 2),
        threads: Ricer::Thread.count, max_threads: Ricer::Thread.peak,
        memory: number_to_human_size(bot.memory), max_memory: number_to_human_size(bot.max_memory),
        pid: Process.pid, cpu: display_cpu_usage
    end
    
    private

    def display_cpu_usage
      number_with_precision(cpu_usage, precision:2)
    end
    
    def cpu_usage
      if OS.posix?
        `ps -o %cpu= -p #{Process.pid}`.to_f
      else
        -0.1
      end
    end
    
  end
end
