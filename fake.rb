require 'optparse'

OptionParser.new do |o|
  o.on("--wow", "this does wow") do |v|
    puts "hey!"
  end
end.parse!