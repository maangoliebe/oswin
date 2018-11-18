require 'readline'

class Oswin
    def initialize
        @h = Hash.new([])
        @events = Hash.new([]) 
    end

    def load(file)
        sub_hash = Hash.new([])
        invalid = []
        line_number = 0
        
        if file == "tasks.txt" then
            File.open(file).each do |line|
                line_number = line_number + 1
                if line =~ /^\[(.+)\] (\d+)h(\d+)m$/ and !@h.has_key?($1) and !sub_hash.has_key?($1) then
                    sub_hash.store($1, (60 * $2.to_i() + $3.to_i()))
                else
                    invalid << line_number
                end
            end

            if invalid.empty? then
                @h.merge!(sub_hash)
                return nil
            else
                print("Error: Invalid Lines\n")
                print(invalid)
                sub_hash.clear
    
                return invalid
            end

        elsif file == "events.txt" then
            File.open(file).each do |line|
                line_number = line_number + 1
                if line =~ /^\[(.+)\] (\d+:\d+)$/ and !@events.has_key?($2) and !sub_hash.has_key?($2) then
                    sub_hash.store($1, $2)
                else
                    invalid << line_number
                end
            end

            if invalid.empty? then
                @events.merge!(sub_hash)
    
                return nil
            else
                print("Error: Invalid Lines\n")
                print(invalid)
                sub_hash.clear
    
                return invalid
            end
        end

    end


    def tasks()
        @h.sort{|a,b| a[1]<=>b[1]}.each do |elem|
            puts "#{elem[1]}, #{elem[0]}"
        end
    end

    def schedule()
        @events.sort{|a,b| a[1]<=>b[1]}.each do |elem|
            puts "#{elem[1]}, #{elem[0]}"
        end
    end

end






# shell code
o = Oswin.new
o.load("tasks.txt")
print("tasks loaded\n")
o.load("events.txt")
print("events loaded\n")


while input = Readline.readline("$ ", true)
  if input == "exit"
    break
  elsif input == "update tasks"
    o.load("tasks.txt")
    print("Done\n")
  elsif input == "update events"
    o.load("events.txt")
    print("Done\n")
  elsif input == "show tasks"
    o.tasks()
  elsif input == "show events"
    o.schedule()
  end

  system(input)
end