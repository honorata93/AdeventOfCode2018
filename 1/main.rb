###############################################################
#                              1                              #
###############################################################

frequency = 0
allFrequencies = [0]

def main
    f = File.open("input.txt", "r")
    data = f.readlines()
    f.close()
    data = data.map(&:to_i)
    # part 1
    puts data.sum

    frequency = 0
    allFrequencies = [0]
    loop do        
        data.each do |change|
            frequency += change  
            if allFrequencies.include?(frequency)
                # part 2
                puts frequency
                return
            else
                allFrequencies.push(frequency)
            end
        end
    end
end

main