#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = scores.map { |s| s == 'X' ? 10 : s.to_i }

# 1～9フレームの処理 (10フレーム目は処理が異なるため後で作成)
current_idx = 0
point = 9.times.sum do
  if shots[current_idx] == 10
    # ストライク：次のフレームの2投分をボーナスとして加算。2投目は投げない。
    next_shots_count = 3
    step = 1
  elsif shots[current_idx] + shots[current_idx + 1] == 10
    # スペア：次のフレームの1投分をボーナスとして加算
    next_shots_count = 3
    step = 2
  else
    # 通常：2投分の合計
    next_shots_count = 2
    step = 2
  end
  frame_score = shots[current_idx, next_shots_count].sum
  current_idx += step
  frame_score
end

# 10フレーム目はそのまま追加 (ストライクかスペアだった場合は最大3投のためまとめて処理)
point += shots[current_idx..].sum

puts point
