require "date"

# if ARGV.length != 4
#   puts "Bad input: amount of args"
#   exit
# end 

teams_file = ARGV[0]
start_date = ARGV[1]
end_date = ARGV[2]
calendar = ARGV[3]

start_date = DateTime.strptime(start_date, "%d.%m.%Y")
end_date = DateTime.strptime(end_date, "%d.%m.%Y")



