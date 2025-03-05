#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

# 計算をしやすくするためストライクを表すXを10点に変換
shots = []
scores.each do |s|
  shots << (s == 'X' ? 10 : s.to_i)
end

frames = []
current_idx = 0

# 1〜9フレームを作成 (10フレーム目は処理が異なるため後で作成)
9.times do
  if shots[current_idx] == 10
    # ストライクの時は2投目なし
    frames << [10]
    current_idx += 1
  else
    # ストライク以外は2投分を追加
    frames << [shots[current_idx], shots[current_idx + 1]]
    current_idx += 2
  end
end
# 10フレーム目の残りの投球を追加 (ストライクかスペアだった場合は最大3投のためまとめて処理)(Ruby2.6以降では[current_idx..-1]より[current_idx..]が推奨されている)
frames << shots[current_idx..]

# 各フレームの開始位置を追加
frame_start_indices = []
idx_counter = 0
frames.each do |frame|
  frame_start_indices << idx_counter
  idx_counter += frame.size
end

# ストライク、スペア時のボーナス加算用に1次元配列に変換
flattened_shots = frames.flatten

point = 0
# 1〜9フレームのスコアを計算
(0..8).each do |frame_idx|
  frame = frames[frame_idx]
  start_idx = frame_start_indices[frame_idx]

  if frame.size == 1 && frame[0] == 10
    # ストライクの場合、次の2投の点数を加算
    bonus1 = flattened_shots[start_idx + 1] || 0
    bonus2 = flattened_shots[start_idx + 2] || 0
    point += 10 + bonus1 + bonus2
  elsif frame.size == 2 && frame.sum == 10
    # スペアの場合、次の1投の点数を加算
    bonus = flattened_shots[start_idx + 2] || 0
    point += 10 + bonus
  else
    # 通常の場合、2投の合計
    point += frame.sum
  end
end

# 10フレーム目はそのまま追加
point += frames[9].sum

puts point
