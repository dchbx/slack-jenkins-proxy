require "slack"

require 'net/http'
require 'uri'
require 'cgi'


Slack.configure do |config|
  config.token = ENV['RUBY_SLACK_TOKEN']
end

client_rt = Slack::RealTime::Client.new
client_web = Slack::Web::Client.new

client_rt.on :hello do
  puts "Client has connected."
end
client_rt.on :close do |_data|
  puts "Client is about to disconnect."
end
client_rt.on :closed do |_data|
  puts "Client has disconnected successfully."
end

client_rt.on :message do |data|
  if defined?(data.file.id) && data.user != ENV['RUBY_SLACK_BOT_USERNAME']
    file = client_web.files_info(
      file: data.file.id
    )
    file_content = file.content
    filename = data.file.name.split(".")

    uri_base = ENV['RUBY_SLACK_JENKINS_JOB_UR']
    params = {
      :token => ENV['RUBY_SLACK_JENKINS_JOB_TOKEN'],
      :hbxid_string => file_content,
      :channel => data.channel,
      :filename => filename[0]
    }

    uri_string = uri_base + "?" + params.map{|k,v| "#{k}=#{CGI::escape(v.to_s)}"}.join('&')
    uri = URI(uri_string)

    Net::HTTP.start(
      uri.host,
      uri.port,
      :use_ssl => uri.scheme == 'https',
      :verify_mode => OpenSSL::SSL::VERIFY_NONE
    ) do |http|
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request request
      p "File contents sent to Jenkins."
    end
  end
end

client_rt.start_async
