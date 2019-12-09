require 'httpclient'

def synthesize(token, input_lang, text, filename)
  headers = {
    'Authorization' => "Bearer #{token}"
  }
  query = {
    text: text,
    lang: input_lang,
    engine: 'nict'
  }

  url = 'https://tts.mimi.fd.ai/speech_synthesis'
  resp = HTTPClient.new.post(url, query, headers)
  if resp.status == 200
    File.open(filename, 'wb') { |f| f.write(resp.body) }
    ['', 200]
  else
    [resp.body, resp.status]
  end
end

if ARGV.size < 4
  warn "Usage: ruby #{__FILE__} access_token input_lang input_text output_filename"
  exit 1
end

token = File.open(ARGV[0], &:read).chomp
_body, status = synthesize(token, ARGV[1], ARGV[2], ARGV[3])
if status != 200
  warn 'ERROR: failed speech synthesis'
  exit 1
end
puts "saved wav file: #{ARGV[3]}"
