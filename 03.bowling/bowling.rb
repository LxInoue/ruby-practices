#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = scores.map { |s| s == 'X' ? 10 : s.to_i }

# 1～9フレームの処理 (10フレーム目は処理が異なるため後で作成)
point = 0
current_idx = 0
9.times do
  if shots[current_idx] == 10
    # ストライク：次のフレームの2投分をボーナスとして加算。2投目は投げない。
    point += (10 + shots[current_idx + 1] + shots[current_idx + 2])
    current_idx += 1
  elsif shots[current_idx] + shots[current_idx + 1] == 10
    # スペア：次のフレームの1投分をボーナスとして加算
    point += (10 + shots[current_idx + 2])
    current_idx += 2
  else
    # 通常：2投分の合計
    point += (shots[current_idx] + shots[current_idx + 1])
    current_idx += 2
  end
end

# 10フレーム目はそのまま追加 (ストライクかスペアだった場合は最大3投のためまとめて処理)
point += shots[current_idx..].sum

puts point
