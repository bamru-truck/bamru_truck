class AlertSettings

  attr_accessor :emails, :timeout, :frequency

  def initialize(params = {})
    @emails    = params.fetch :emails,    "andy@r210.com,mgregg@michaelgregg.com"
    @timeout   = params.fetch :timeout,   15
    @frequency = params.fetch :frequency, 240
  end

end

