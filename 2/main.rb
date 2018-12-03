def main
    f = File.open("input.txt", "r")
    data = f.readlines()
    f.close()
    
    occuringCounts=Hash.new
    data.each do |word|
        letters = Hash.new;
        word.split('').each { |l|
            if letters.key?(l)
                letters[l] += 1
            else
                letters[l] = 1 
            end            
        }

        checkCount = [2, 3] 
        checkCount.each do |c|            
            if letters.has_value?(c)
                if occuringCounts.key?(c) 
                    occuringCounts[c] += 1
                else
                    occuringCounts[c] = 1
                end
            end
        end
    end

    checkSum=1
    occuringCounts.each do | key, value|
        checkSum *= value
    end
    puts checkSum

    data.each do |base|
        data.each do |compare|
            index = oneDifference(base, compare)
            if index != nil
                print base[0...index].to_s + base[index+1..-1].to_s

                return
            end
        end    
    end
end
 
def oneDifference(base, compare)
    i = 0
    count = 0
    while i < compare.length
        if base.split('')[i] != compare.split('')[i]
           count += 1 
           index = i  
        end
        i += 1
    end

    if count == 1
        return index
    end

    return nil
end

main

