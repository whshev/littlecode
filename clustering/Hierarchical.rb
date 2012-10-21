def both(*enumerables)   
    enumerators = enumerables.map { |e| e.to_enum }   
    loop { yield enumerators.map { |e| e.next } }   
end

def dis(x1, x2)
    sum = 0.0
    both(x1, x2) { |i, j| sum += (i - j) ** 2 }
    #x1.inject(0.0) { |sum, x| sum + (x - x2[n])**2 }
    #x1.length.times { |n| sum += (x1[n] - x2[n])**2 }
    Math.sqrt(sum)
end

data = []
STDIN.each do |line|
    x = []
    line.split.each { |num| x << num.to_i }
    data << [x]
end

3.times do
    mindis, minx1, minx2 = nil, nil, nil
    data.length.times do |i|
        (i+1).upto(data.length - 1) do |j|
            mind = nil
            data[i].each do |x1|
                data[j].each do |x2|
                    if mind == nil || dis(x1, x2) < mind
                        mind = dis(x1, x2)
                    end
                end
            end
            print mind.round(3)
            print " "
            if mindis == nil || mind < mindis
                mindis, minx1, minx2 = mind, i, j
            end
        end
        print "\n"
    end
    data[minx1] |= data[minx2]
    data.delete_at(minx2)
    print data
    print "\n"
end
