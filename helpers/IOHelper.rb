class IOHelper
  def self.append_file(content, filename)
    File.open(filename, 'a') { |f| f.write(content) }
  end

  def self.write_file(content, filename)
    File.open(filename, 'w') { |f| f.write(content) }
  end
end
