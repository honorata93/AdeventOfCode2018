def main
    f = File.open("input.txt", "r")
    data = f.readlines()
    f.close()
    
    print data
    gets
end

main