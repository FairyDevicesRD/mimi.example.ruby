require 'websocket-eventmachine-client'
require 'eventmachine'
require 'json'

SAMPLES_PER_CHUNK = 8192

def recognize(token, file_data)
  uri = 'wss://service.mimi.fd.ai:443'
  headers = {
    "Authorization": "Bearer #{token}",
    "x-mimi-process": 'asr',
    "x-mimi-input-language": 'ja',
    "Content-Type": 'audio/x-pcm;bit=16;rate=16000;channels=1'
  }

  EM.run do
    ws = WebSocket::EventMachine::Client.connect uri: uri, headers: headers

    ws.onopen do
      file_size = file_data.size
      sent_size = 0
      while sent_size < file_size
        chunk = file_data.byteslice(
          sent_size..[sent_size + SAMPLES_PER_CHUNK * 2, file_data.size].min - 1
        )
        ws.send chunk, type: 'binary'

        sent_size += chunk.size
        puts "sent #{sent_size}"
      end

      puts 'break'
      ws.send JSON.generate("command": 'recog-break'), type: 'text'
    end

    ws.onmessage do |msg|
      puts msg
    end

    ws.onclose do |e|
      p [:close, e]
      EM.stop
    end

    ws.onerror do |e|
      p [:error, e]
    end
  end
end

if ARGV.size < 2
  warn "Usage: ruby #{__FILE__} access_token audio_file"
  exit 1
end

token = File.open(ARGV[0], &:read).chomp
file_data = IO.binread(ARGV[1])
puts file_data.size

begin
  recognize(token, file_data)
rescue StandardError => e
  warn e
end
