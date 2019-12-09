require 'websocket-client-simple'
require 'eventmachine'
require 'json'

SAMPLES_PER_CHUNK = 8192

def recognize(token, file_data)
  headers = {
    "Authorization": "Bearer #{token}",
    "x-mimi-process": 'nict-asr',
    "x-mimi-input-language": 'ja',
    "Content-Type": 'audio/x-pcm;bit=16;rate=16000;channels=1'
  }

  EM.run do
    uri = 'wss://dev-service.mimi.fd.ai:443'
    # uri = 'ws://127.0.0.1:18888'
    # uri = 'wss://dev-service-cats-sugunikesu.mimi.fd.ai:443'

    ws = WebSocket::Client::Simple.connect uri, headers: headers
    ws.on :message do |msg|
      # j = JSON.load(msg)
      puts msg
    end

    ws.on :open do
      puts 'hello'

      file_size = file_data.size
      sent_size = 0
      while sent_size < file_size
        chunk = file_data.byteslice(
          sent_size..[sent_size + SAMPLES_PER_CHUNK * 2, file_data.size].min - 1
        )
        puts chunk.size
        ws.send chunk

        sent_size += chunk.size
        puts "sent #{sent_size}"
        # sleep 0.3
      end

      puts 'break'
      ws.send(JSON.generate("command": 'recog-break'))
    end

    ws.on :close do |e|
      p e
      EM.stop
    end

    ws.on :error do |e|
      p e
      EM.stop
    end
  end
end

if ARGV.size < 2
  puts "Usage: ruby #{__FILE__} access_token audio_file"
  exit 1
end

token = File.open(ARGV[0], &:read).chomp
# file_data = File.open(ARGV[1], 'rb').read
file_data = IO.binread(ARGV[1])
puts file_data.size

puts 'start recognition...'
begin
  recognize(token, file_data)
rescue StandardError => e
  puts e
end
