module AppHelpers
  def raspi?
    RbConfig::CONFIG["arch"].match(/arm-linux/)
  end

  # ----- environment testing ----------------------------------

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
      erb "THERE WAS AN ERROR"
    end
  end

  # ----- header nav -------------------------------------------

  def link_to_unless_current(path, label)
    return label if path == request.path_info
    "<a href='#{path}'>#{label}</a>"
  end

  def navdata
    %w(/:Home /token:Token) +
    %w(/gps_packets:20_GPS_Packets /cell_modem_status:Cell_Modem_Status)
  end

  def navbar
    navdata.map do |el|
      link_to_unless_current(*el.split(':'))
    end.join(' | ')
  end
end
