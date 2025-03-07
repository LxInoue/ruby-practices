#!/usr/bin/env ruby

require "date"
require "optparse"
today = Date.today
year = today.year
month = today.month

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
unless (1970..2100).cover?(year)
  abort("エラー：-yは1970〜2100の範囲で指定してください。")
end
unless (1..12).cover?(month)
  abort("エラー：-mは1〜12の範囲で指定してください。")
end

first_date = Date.new(year, month, 1)
last_date  = Date.new(year, month, -1)

puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
print "   " * first_date.wday

(first_date..last_date).each do |current_date|
  day = current_date.day
  if today == current_date
    print "\e[7m" + day.to_s.rjust(2) + "\e[0m "
  else
    print day.to_s.rjust(2) + " "
  end
  puts if current_date.saturday?
end
puts
