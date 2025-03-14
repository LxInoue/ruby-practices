#!/usr/bin/env ruby
# frozen_string_literal: true

def fetch_entries
  entries = Dir.entries('.')
  entries.reject { |name| name.start_with?('.') }.sort
end

def print_entries(entries, columns = 3)
  rows = format_rows(entries, columns)
  col_widths = calculate_column_widths(rows, columns)
  output_rows(rows, col_widths, columns)
end

def format_rows(entries, columns)
  row_count = (entries.size.to_f / columns).ceil
  rows = Array.new(row_count) { Array.new(columns, '') }

  entries.each_with_index do |entry, i|
    col = i / row_count
    row = i % row_count
    rows[row][col] = entry
  end
  rows
end

def calculate_column_widths(rows, columns)
  (0...columns).map do |col|
    rows.map { |row| row[col].length }.max
  end
end

def output_rows(rows, col_widths, columns)
  rows.each do |row|
    row.each_with_index do |entry, idx|
      if idx == columns - 1
        print entry.ljust(col_widths[idx])
      else
        print entry.ljust(col_widths[idx] + 8)
      end
    end
    puts
  end
end

entries = fetch_entries
print_entries(entries)
