require 'httpclient'

def translate(token, input_lang, text, output_lang)
  headers = {
    'Authorization' => "Bearer #{token}"
  }
  query = {
    text: text,
    source_lang: input_lang,
    target_lang: output_lang
  }

  url = 'https://tra.mimi.fd.ai/machine_translation'
  client = HTTPClient.new
  resp = client.post(url, query, headers)
  [resp.body, resp.status]
end

if ARGV.size < 4
  warn "Usage: ruby #{__FILE__} access_token input_lang input_text output_lang"
  exit 1
end

token = File.open(ARGV[0], &:read).chomp
body, status = translate(token, ARGV[1], ARGV[2], ARGV[3])
if status != 200
  warn 'ERROR: failed machine translation'
  exit 1
end

puts body
