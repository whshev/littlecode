def both(*enumerables)   
  	enumerators = enumerables.map { |e| e.to_enum }   
  	loop { yield enumerators.map { |e| e.next } }   
end

def dis(x1, x2)
    sum = 0.0
    both(x1, x2) { |i, j| sum += (i - j) ** 2 }
    Math.sqrt(sum)
end

def avgx(x)
	sum = x[0].dup
	1.upto(x.length - 1) do |i|
		x[i].length.times { |j| sum[j] += x[i][j] }
	end
	sum.collect { |xi| xi.to_f / x.length }
end

k = STDIN.readline.to_i
ans = []
1.upto(k) do |i|
	x = STDIN.readline.split.collect { |num| num.to_i }
	ans << [x]
end
data = []
STDIN.each do |line|
	data << line.split.collect { |num| num.to_i }
end
mid = ans.collect { |x| avgx(x) }

preans, h = [], {}
while preans != ans do
	# print mid
	# print "\n"
	preans = ans.dup
	data.each do |xi|
		mind, minid = nil, nil
		mid.each_index do |i|
			if mind == nil || dis(mid[i], xi) < mind
				mind, minid = dis(mid[i], xi), i
			end
		end
		ans[minid] |= [xi]
		if h[xi] != nil && h[xi] != minid
			ans[h[xi]].delete(xi)
		end
		h[xi] = minid
	end
	print ans
	print "\n"
	mid = ans.collect { |x| avgx(x) }
end
