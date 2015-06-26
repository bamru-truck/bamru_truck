module AppHelpers
  def raspi?
    RbConfig::CONFIG["arch"].match(/arm-linux/)
  end

  def raspi_only
    if raspi?
      yield
    else
      erb "ONLY RUNS ON RASPBERRY PI"
    end
  end

  def safe_exec
    begin
      yield
    rescue
      "THERE WAS AN ERROR"
    end
  end

  def link_to_unless_current(path, label)
    return label if path == request.path_info
    "<a href='#{path}'>#{label}</a>"
  end

  def navdata
    %w(/:Home /sys:Sys /erb:Token /time:Time /ls:LS) +
    %w(/gps_packets:20_GPS_Packets /cell_modem_status:Cell_Modem_Status)
  end

  def navbar
    navdata.map do |el|
      link_to_unless_current(*el.split(':'))
    end.join(' | ')
  end
end
