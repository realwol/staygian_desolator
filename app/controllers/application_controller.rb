class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # around_filter :record_memory if Rails.env.production?
  around_filter :log_rss if Rails.env.production?
  # before_action :curfew_in_work

  def curfew_in_work
    if Rails.env == 'production' && current_user.present? && !current_user.is_dd?
      render text: '系统正在维护，请稍后再试！', status: 404 unless time_in_curfew Time.now
    end
  end

  def time_in_curfew time
    work_start = time.beginning_of_day + 7.hours + 30.minutes
    work_end   = time.end_of_day - 4.hours - 30.minutes
    time > work_start && time < work_end
  end

  def selected_user
    @selected_user = (session[:selected_user_id].present? && User.where(id: session[:selected_user_id]).first.present?) ? User.where(id: session[:selected_user_id]).first : current_user

    @selected_user
  end

  def record_memory
    process_status = File.open("/proc/#{Process.pid}/status")
    13.times {process_status.gets}
    res_before_action = process_status.gets.split[1].to_i
    process_status.close
    yield
    process_status = File.open("/proc/#{Process.pid}/status")
    13.times {process_status.gets}
    res_after_action = process_status.gets.split[1].to_i
    process_status.close
    logger.info("CONSUME MEMORY: #{res_after_action - res_before_action} KB\t NOW #{res_after_action} KB\t #{request.url}")
  end

  def log_rss
    before_rss,before_rss_t = _worker_rss
    yield
    after_rss,after_rss_t = _worker_rss
    after_rss_t ||= 0
    before_rss_t ||= 0
    # show bigger than about 10M
    if after_rss_t - before_rss_t > 10000000
      file_path = "#{Rails.root.dirname.dirname}/shared/log/mem_trace.log"
      trace_file = File.open file_path, 'a'
      trace_file.puts "#{controller_name} #{action_name} rss info #{Process.pid} VmRSS: #{after_rss.to_i - before_rss.to_i}\n"
      trace_file.close
    end
  end

  def _worker_rss
    proc_status = "/proc/#{Process.pid}/status"
    if File.exists? proc_status
      open(proc_status).each_line { |l|
        if l.include? 'VmRSS'
          ls = l.split
          if ls.length == 3
            value = ls[1].to_i
            unit = ls[2]
            val = case unit.downcase
                  when 'kb'
                    value*(1024**1)
                  when 'mb'
                     value*(1024**2)
                  when 'gb'
                     value*(1024**3)
                  end
            return ["#{value} #{unit}",val]
          end
        end
      }
      ["0",0]
    end
    ["0",0]
  end
end
