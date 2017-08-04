require 'net/scp'

class UploadHelper
  def self.upload_file(tempfile, filename, servers, scp_user, upload_dir)
    puts "received file: #{filename}"
    puts "servers: #{servers}" 

    servers.each do |server|
      Net::SCP.start(server, scp_user) do |scp|
        # synchronous (blocking) upload; call blocks until upload completes

        # scp.upload! tempfile, "#{upload_dir}/#{filename}" do |ch, name, sent, total|
        #   puts "#{name}: #{sent}/#{total}"
        # end

        # asynchronous upload; call returns immediately and requires SSH
        # event loop to run
        channel = scp.upload(tempfile, "#{upload_dir}/#{filename}") #do |ch, name, sent, total|
          #puts "#{name}: #{sent}/#{total}"
        channel.wait
        #end
        # channel = scp.upload("/local/path", "/remote/path")
        # channel.wait
      end
    end
  end
end





