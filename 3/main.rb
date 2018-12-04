def main
    f = File.open("input.txt", "r")
    data = f.readlines()
    f.close()
    
    occupiedCounts = Hash.new

    data.each do |line|
        rectangleParams = line.split(/[#@: ,x\n]/).reject(&:empty?).map(&:to_i)
        x = rectangleParams[1]
        y = rectangleParams[2]
        width = rectangleParams[3]
        height = rectangleParams[4]
        addCoordinates(x, y, width, height, occupiedCounts)
    end

    data.each do |line|
        rectangleParams = line.split(/[#@: ,x\n]/).reject(&:empty?).map(&:to_i)
        id = rectangleParams[0]
        x = rectangleParams[1]
        y = rectangleParams[2]
        width = rectangleParams[3]
        height = rectangleParams[4]
        if !isOccupied(x, y, width, height, occupiedCounts)
            # part 2
            puts id
        end        
    end

    # part 1
    print countOverlapping(occupiedCounts)
end

def addCoordinates(x, y, width, height, occupiedCounts)
    startY = y
    i=0
    while i < width
        j = 0
        y = startY 
        while j < height
            if occupiedCounts.key?(x.to_s + "," + y.to_s)
                occupiedCounts[x.to_s + "," + y.to_s] += 1
            else
                occupiedCounts[x.to_s + "," + y.to_s] = 1
            end   
            y += 1
            j += 1
        end            
        x += 1
        i += 1
    end
end

def countOverlapping(occupiedCounts)
    count = 0
    occupiedCounts.each { |key, value|
        if value > 1
            count += 1
        end        
    }

    return count
end

def isOccupied(x, y, width, height, occupiedCounts)
    startY = y
    i=0
    while i < width
        j = 0
        y = startY 
        while j < height
            if occupiedCounts[x.to_s + "," + y.to_s] > 1
                return true 
            end             
            y += 1
            j += 1
        end            
        x += 1
        i += 1
    end

    return false
end

main