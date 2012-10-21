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

def devi(x)
	z = avgx(x)
	stand = []
	z.each_index { |i| stand << Math.sqrt(x.inject(0.0) { |sum, xi| sum + ((xi[i] - z[i]) ** 2) } / x.length) }
	return stand
end

k = STDIN.readline.to_i
n = STDIN.readline.to_i
s = STDIN.readline.to_f
c = STDIN.readline.to_f
l = STDIN.readline.to_i
maxi = STDIN.readline.to_i
nc = STDIN.readline.to_i

ans = []
1.upto(nc) do |i|
	x = STDIN.readline.split.collect { |num| num.to_i }
	ans << [x]
end
data = []
STDIN.each do |line|
	data << line.split.collect { |num| num.to_i }
end
mid = ans.collect { |x| avgx(x) }

h = {}
maxi.times do |i|
	# print ans
	# print "\n"
	# print mid
	# print "\n"
	ans.clear
	ans = Array.new(mid.length, [])
	h.clear
	while true do
		data.each do |xi|
			mind, minid = nil, nil
			mid.each_index do |j|
				if mind == nil || dis(mid[j], xi) < mind
					mind, minid = dis(mid[j], xi), j
				end
			end
			ans[minid] |= [xi]
			if h[xi] != nil && h[xi] != minid
				ans[h[xi]].delete(xi)
			end
			h[xi] = minid
		end
		del = ans.collect { |xi| xi if xi.length < n }
		del.each { |xi| ans.delete(xi) }
		break if del[0] == nil
	end
	mid = ans.collect { |x| avgx(x) }
	# print mid
	# print "\n"
	avgsj = []
	mid.each_index do |j|
		avgsj << ans[j].inject(0.0) { |sum, xi| sum + dis(xi, mid[j]) } / ans[j].length
	end
	# print avgsj
	# print "\n"
	sum = 0.0
	avgsj.each_index { |j| sum += avgsj[j] * ans[j].length }
	avgs = sum / data.length
	# print avgs
	# print "\n"
	if (ans.length << 1) <= k || (((i+1) & 1) == 1 && ans.length < (k << 1))
		if i >= maxi
			c = 0
			break
		end
		stand = ans.collect { |x| devi(x) }
		stand.each_index do |j|
			maxs, maxid = stand[j][0], 0
			stand[j].each_index do |x|
				if stand[j][x] > maxs
					maxs = stand[j][x]
					maxid = x
				end
			end
			if maxs > s && ((avgsj[j] > avgs && ans[j].length > ((n + 1) << 1)) || (ans.length << 1) <= k)
				z1 = mid[j].dup
				z2 = mid[j].dup
				z1[maxid] += maxs
				z2[maxid] -= maxs
				mid[j] = z1.dup
				mid << z2
			end
		end
		# print stand
		# print "\n"
		next if mid.length != ans.length
	end
	dd = []
	mid.each_index do |j|
		(j+1).upto(mid.length - 1) { |x| dd << [j, x, dis(mid[j], mid[x])] if dis(mid[j], mid[x]) < c }
	end
	# print dd
	# print "\n"
	dd.sort! { |a, b| a[3] <=> b[3] } if dd.length >= 2
	ha, zz = {}, []
	dd.each_index do |j|
		break if j > l
		x = dd[j]
		if ha[x[0]] == nil && ha[x[1]] == nil
			zz << [x[0], x[1]]
			ha[x[0]] = zz.length - 1
			ha[x[1]] = zz.length - 1
		elsif ha[x[0]] != nil && ha[x[1]] == nil
			zz[ha[x[0]]] << x[1]
			ha[x[1]] = ha[x[0]]
		elsif ha[x[0]] == nil && ha[x[1]] != nil
			zz[ha[x[1]]] << x[0]
			ha[x[0]] = ha[x[1]]
		elsif ha[x[0]] != ha[x[1]]
			tmp = ha[x[1]]
			zz[tmp].each { |xx| ha[xx] = ha[x[0]] }
			zz[ha[x[0]]] |= zz[tmp]
			zz[tmp].clear
		end
	end
	zz.each do |x|
		if x.length >= 2
			sumn = x.inject(0.0) { |sum, xi| sum + ans[xi].length }
			mid[0].each_index do |j|
				mid[x[0]][j] = x.inject(0.0) { |sum, xi| sum + mid[xi][j] * ans[xi].length / sumn }
			end
			1.upto(x.length - 1) do |j|
				ans[x[0]] |= ans[x[j]]
				ans[x[j]].clear
				mid[x[j]].clear
			end
			ans.delete([])
			mid.delete([])
		end
	end
end
print ans
print "\n"