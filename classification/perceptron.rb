def both(*enumerables)   
  	enumerators = enumerables.map { |e| e.to_enum }   
  	loop { yield enumerators.map { |e| e.next } }   
end

def multi(x1, x2)
	ans = 0
	both(x1, x2) { |i, j| ans += i * j }
	return ans
end

def plus(x1, x2)
	ans = []
	both(x1, x2) { |i, j| ans << i + j }
	return ans
end

def minus(x1, x2)
	ans = []
	both(x1, x2) { |i, j| ans << i - j }
	return ans
end

kind = STDIN.readline.to_i
raw_data = []
STDIN.each do |line|
	raw_data << line.split.collect { |num| num.to_i }
end
data = []
if kind == 2
	raw_data.each do |v|
		x = v[0] - 1
		d = (-1) ** x
		vv = []
		1.upto(v.length-1) { |i| vv << v[i] * d }
		vv << d
		if data[x] == nil
			data[x] = [vv]
		else
			data[x] << vv
		end
	end
	# print data
	# print "\n"
	c = 1
	w = Array.new(data[0][0].length, 0)
	ww = []
	while w != ww
		ww = w.dup
		data.each_index do |i|
			data[i].each do |v|
				if multi(v, w) <= 0
					w = plus(v, w)
					print w
					print "\n"
				end
			end
		end
	end
else
	raw_data.each do |v|
		x = v[0] - 1
		vv = []
		1.upto(v.length-1) { |i| vv << v[i] }
		vv << 1
		if data[x] == nil
			data[x] = [vv]
		else
			data[x] << vv
		end
	end
	# print data
	# print "\n"
	c = 1
	w = Array.new(data.length, Array.new(data[0][0].length, 0))
	print w
	print "\n"
	ww = []
	while w != ww
		ww = w.dup
		data.each_index do |i|
			data[i].each do |v|
				di = multi(v, w[i])
				flag = false
				w.each_index do |j|
					if j != i && multi(v, w[j]) >= di
						flag = true
						w[j] = minus(w[j], v);
					end
				end
				w[i] = plus(w[i], v) if flag
			end
			print w
			print "\n"
		end
		# print ww
		# print "\n"
	end
end