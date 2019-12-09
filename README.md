# Sample client for mimi in Ruby

## Preparation

1. execute Bundler.

```sh
bundle install
```

2. get access token.

    - see [here](https://mimi.readme.io/docs/auth-api#section-13-%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E6%A8%A9%E9%99%90%E3%81%A7%E3%81%AE%E7%99%BA%E8%A1%8C%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E5%86%85%E3%81%AB%E9%96%89%E3%81%98%E3%81%9F-root-%E6%A8%A9%E9%99%90).

## Execution

### Speech Recognition

```sh
ruby asr.rb access_token_file audio_file

ex.
ruby asr.rb token.txt audio.raw
#=> { "response" : [ { "pronunciation" : "チョット", "result" : "ちょっと", "time" : [ 580, 1030 ] }, { "pronunciation" : "オソイ", "result" : "遅い", "time" : [ 1030, 1390 ] }, { "pronunciation" : "チューショク", "result" : "昼食", "time" : [ 1390, 1890 ] }, { "pronunciation" : "ヲ", "result" : "を", "time" : [ 1890, 1980 ] }, { "pronunciation" : "トル", "result" : "とる", "time" : [ 1980, 2220 ] }, { "pronunciation" : "タメ", "result" : "ため", "time" : [ 2220, 2610 ] }, { "pronunciation" : "ファミリー", "result" : "ファミリー", "time" : [ 2930, 3480 ] }, { "pronunciation" : "レストラン", "result" : "レストラン", "time" : [ 3480, 4020 ] }, { "pronunciation" : "ニ", "result" : "に", "time" : [ 4020, 4150 ] }, { "pronunciation" : "ハイッ", "result" : "入っ", "time" : [ 4150, 4450 ] }, { "pronunciation" : "タ", "result" : "た", "time" : [ 4450, 4540 ] }, { "pronunciation" : "ノ", "result" : "の", "time" : [ 4540, 4680 ] }, { "pronunciation" : "デス", "result" : "です", "time" : [ 4680, 5100 ] } ], "session_id" : "ab86a468-ced4-11e9-915b-42010a92008b", "status" : "recog-finished", "type" : "asr#mimilvcsr" }
```

### Machine Translation

```sh
ruby tra.rb  access_token_file input_lang input_text output_lang

ex.
ruby tra.rb token.txt ja "こんにちは" en
#=> ['Hello.']
```

### Speech Synthesis

```sh
ruby tts.rb access_token_file input_lang input_text output_filename

ex.
ruby tts.rb token ja "こんにちは" out.wav
```
