def main
    f = File.open("input.txt", "r")
    data = f.readlines()
    f.close()
    
    polymer = scanPolymer(data[0])
    # part 1
    puts polymer.size
    
    min = data[0].size
    for i in 'A'.ord..'Z'.ord
        units = i.chr + i.chr.downcase
        remainigPolymer = removeUnits(data[0], units)
        length = scanPolymer(remainigPolymer).size
        if length < min 
            min = length
        end
    end

    # part 2
    puts min
end

def scanPolymer(data)
    polymer = []
    i = 0
    for i in 0...data.size 
        curr = data[i]
        if !polymer.empty?
            prev = polymer.pop
            # triggered: the same type but opposite polarity
            if prev.downcase == curr.downcase && prev != curr 
                next
            end  
            polymer.push(prev)
        end    
        polymer.push(curr)
    end

    return polymer
end

def removeUnits(data, units)
    return data.tr(units, '')
end

main