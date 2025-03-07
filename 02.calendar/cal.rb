#!/usr/bin/env ruby

require "date"
require "optparse"

year = Date.today.year
month = Date.today.month

# オプションの読み込みと入力チェック
opt = OptionParser.new
opt.on("-y YEAR", Integer, "年を指定（例：2025）") { |y| year = y }
opt.on("-m MONTH", Integer, "月を指定（例：3）") { |m| month = m }
begin
  opt.parse!(ARGV)
rescue OptionParser::InvalidArgument => e
  STDERR.puts "エラー：#{e.message}"
  STDERR.puts opt
  STDERR.puts "無効な値です。オプションは半角の整数で指定してください。"
  STDERR.puts "例：cal.rb -y 2025 -m 5"
  exit 1
end
# UNIXエポックタイムに基づき1970年以前をサポートしない。また、上限を設けるために2100年を設定している。
unless (1970..2100).include?(year)
  abort("エラー：-yは1970〜2100の範囲で指定してください。")
end

# 年月日の作成とチェック
begin
  first_date = Date.new(year, month, 1)
rescue ArgumentError
  abort("エラー：不正な年または月が指定されました。")
end

# ヘッダーの出力
puts "#{first_date.month}月 #{first_date.year}".center(20)
puts "日 月 火 水 木 金 土"

# 1日の曜日まで空白を出力
print "   " * first_date.wday

# 最終日を算出して出力
last_day = Date.new(first_date.year, first_date.month, -1).day
display_date = first_date
(1..last_day).each do |day|
  if Date.today == display_date
    # 今日の日付の場合は反転表示させる。
    print "\e[7m" + day.to_s.rjust(2) + "\e[0m "
  else
    print day.to_s.rjust(2) + " "
  end
  display_date = display_date.next
  puts if display_date.sunday?
end
puts
