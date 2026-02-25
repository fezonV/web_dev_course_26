require "date"
TIMES = ["12:00", "15:00", "18:00"].freeze
ALLOWED_WEEKDAYS = [5, 6, 0].freeze


if ARGV.length != 4
   puts "Bad input: amount of args"
   exit
end 
# функция для парсинга команд из текстового файла
def read_teams(path)
  unless File.exist?(path) && File.file?(path) && File.readable?(path)
    puts "Bad input"
    exit 1
  end
  teams = []
  File.readlines(path, chomp: true).each do |line|
    line = line.strip
    next if line.empty?
    parts = line.split(" — ")
    if parts.length < 2 || parts[0].empty? || parts[1].empty?
      puts "Bad line"
      exit
    end 
    
    teams << [parts[0], parts[1]]
    
  end
  if teams.length < 2
      puts "Not enought teams"
      exit
    end
  teams
end

teams_file = ARGV[0]
start_date = ARGV[1]
end_date = ARGV[2]
calendar = ARGV[3]

begin
  start_date = Date.strptime(start_date, "%d.%m.%Y")
  end_date = Date.strptime(end_date, "%d.%m.%Y")
rescue ArgumentError
  puts "Bad input: wrong date format (use DD.MM.YYYY)"
  exit 1
end

if start_date > end_date
  puts "Bad input: wrond dates"
  exit
end

teams = read_teams(teams_file)

matches = []

# генерируем всевозможные пары
for i in 0...teams.length
  for j in (i+1)...teams.length
    matches << [teams[i], teams[j]]
  end
end

current = start_date

# создаем слоты для игр
slots = []
while current <= end_date
  if !ALLOWED_WEEKDAYS.include?(current.wday)
    current += 1
    next
  end
  slots << [current, TIMES[0]]
  slots << [current, TIMES[1]]
  slots << [current, TIMES[2]]
  current += 1
end

slots2 = []

slots.each do |s|
  slots2 << {
    date: s[0],
    time: s[1],
    games: []
  }
end

capacity = slots2.length

if matches.length > capacity * 2
  puts "Bad input: not enough slots"
  exit 1
end

if matches.empty?
  puts "No matches"
  exit 1
end
if slots2.empty?
  puts "No playable dates in range"
  exit 1
end
step = capacity.to_f / matches.length
position = 0.0

matches.each do |match|
  slot_index = position.floor

  # если в слоте уже 2 игры -> ищем следующий
while slot_index < slots2.length && slots2[slot_index][:games].length >= 2
  slot_index += 1
end

if slot_index == slots2.length
  puts "Bad input: not enough slots"
  exit 1
end

  slots2[slot_index][:games] << match
  position += step
end
busy = slots2.select { |s| !s[:games].empty? }

busy.sort_by! { |s| [s[:date], s[:time]] }

File.open(calendar, "w") do |f|
  current_date = nil

  busy.each do |slot|
    if current_date != slot[:date]
      current_date = slot[:date]
      f.puts current_date.strftime("%d.%m.%Y")
    end

    slot[:games].each do |match|
      a = match[0] # [name, city]
      b = match[1]

      f.puts "  #{slot[:time]} #{a[0]} (#{a[1]}) vs #{b[0]} (#{b[1]})"
    end
  end
end

puts "Written to #{calendar}"