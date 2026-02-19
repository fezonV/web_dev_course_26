require "date"
TIMES = ["12:00", "15:00", "18:00"].freeze
ALLOWED_WEEKDAYS = [5, 6, 7].freeze


 if ARGV.length != 4
   puts "Bad input: amount of args"
   exit
end 

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

teams_file = ARGV[0]
start_date = ARGV[1]
end_date = ARGV[2]
calendar = ARGV[3]

start_date = DateTime.strptime(start_date, "%d.%m.%Y")
end_date = DateTime.strptime(end_date, "%d.%m.%Y")

if start_date > end_date
  puts "Bad input: wrond dates"
  exit
end

if !File.exists?(teams_file) || !File.readable?(teams_file)
  puts "Bad input: wrong teams file"
  exit
end


