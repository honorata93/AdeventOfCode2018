require 'date'
EVENT_SHIFT = "SHIFT"
EVENT_ASLEEP = "ASLEEP"
EVENT_WAKE_UP = "WAKE_UP"
Event = Struct.new(:datetime, :type, :id)

def main
    f = File.open("input.txt", "r")
    data = f.readlines()
    f.close()
    
    events = parseInput(data)
    asleepTimes = markAsleepTimes(events)
    ids = getIdPerDay(events)
    asleepPerDay = countAsleepPerDay(asleepTimes, ids)
    asleepPerId = countAsleepPerId(asleepPerDay, ids)
    maxId = asleepPerId.max_by { |id, min| min }[0]
    maxMinute, maxFreq = getMostFrequentAsleepMinute(asleepTimes, ids, maxId)
    # part 1
    puts maxId * maxMinute

    # part 2
    maxId = -1
    maxMinute = -1
    maxFreq = -1
    asleepPerId.each do |id, min|
        maxMinuteTemp, maxFreqTemp = getMostFrequentAsleepMinute(asleepTimes, ids, id)
        if maxFreqTemp > maxFreq
            maxFreq = maxFreqTemp
            maxMinute = maxMinuteTemp
            maxId = id
        end        
    end
    
    puts maxId * maxMinute
end

def parseInput(data)
    events = Array.new

    data.each do |line|
        startTimePos = 1
        dateFormat = '%Y-%m-%d %H:%M'
        finishTimePos = startTimePos+"1518-09-04 00:06".length-1
        
        # time of event
        datetime = DateTime.strptime(line[startTimePos,finishTimePos], dateFormat)
        datetime = setNextDay(datetime)

        # type of event
        case line[finishTimePos+3]
            when "G"
                line = line.split(/[ #\n]/).reject(&:empty?)
                events.push(Event.new(datetime, EVENT_SHIFT, line[3].to_i))
            when "f"
                events.push(Event.new(datetime, EVENT_ASLEEP))
            when "w"
                events.push(Event.new(datetime, EVENT_WAKE_UP))
        end            
    end

    events = events.sort_by{ |e| e.datetime}
    return events
end

def setNextDay(datetime)
    return datetime.hour == 23 ? datetime + Rational(60-datetime.min, 24*60) : datetime
end

def markAsleepTimes(events)
    asleepTimes = Hash.new
    i = 0
    while i < events.size
        ev = events[i]
        if ev.type == EVENT_ASLEEP
            i += 1 
            ev_next = events[i]
            date = Date.new(ev.datetime.year, ev.datetime.month, ev.datetime.mday)
            min_start = ev.datetime.min
            min_end = ev_next.datetime.min
            j = min_start
            while  min_start < min_end
                asleepTimes[[date, min_start]] = true
                min_start += 1
            end
        end
        
        i += 1
    end
    
    return asleepTimes
end

def getIdPerDay(events)
    ids = Hash.new
    i = 0
    while i < events.size
        ev = events[i]
        if ev.type == EVENT_SHIFT
            date = Date.new(ev.datetime.year, ev.datetime.month, ev.datetime.mday)
            ids[date] = ev.id
        end
        
        i += 1
    end    

    return ids
end

def countAsleepPerDay(asleepTimes, ids)    
    asleepPerDay = Hash.new
    asleepTimes.each do |key, value|
        day = key[0]
        if asleepPerDay.include?(day)
            asleepPerDay[day] += 1
        else
            asleepPerDay[day] = 1
        end
    end
    
    return asleepPerDay
end

def countAsleepPerId(asleepPerDay, ids)
    asleepPerId = Hash.new
    # puts ids
    asleepPerDay.each do |day, minutes|
        id = ids[day]
        if asleepPerId.include?(id)
            asleepPerId[id] += minutes
        else
            asleepPerId[id] = minutes
        end
    end
    
    return asleepPerId
end

def getMostFrequentAsleepMinute(asleepTimes, ids, id)
    minutesFrequency = Hash.new
    asleepTimes.each do |key, value|
        i = ids[key[0]]
        if i == id

            min = key[1]
            if minutesFrequency.include?(min)
                minutesFrequency[min] += 1
            else
                minutesFrequency[min] = 1
            end
        end
                
    end

    maxMinute = minutesFrequency.max_by { |min, freq| freq}[0]
    maxFreq = minutesFrequency.max_by { |min, freq| freq}[1]
    return maxMinute, maxFreq 
end

main
