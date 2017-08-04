class LogHelper
  def initialize(*destinations)
    @destinations = destinations
  end

  def write(*args)
    @destinations.each { |d| d.write(*args) }
  end

  def close()
    @destinations.each(&:close)
  end
end
