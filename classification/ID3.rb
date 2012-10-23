$data, $label = [], []
STDIN.each do |line|
  l = line.split
  $label << (l[-1] == "yes" ? true : false)
  l.delete_at(-1)
  $data << l
end

def both(*enumerables)
  enumerators = enumerables.map { |e| e.to_enum }   
  loop { yield enumerators.map { |e| e.next } }   
end

class Tree
  attr_accessor :flag, :attribute, :children, :entropy, :atindex
  def initialize()
    @entropy = 0.0
    @atindex = 0
    @attribute = []
    @children = []
    @flag = nil
  end

  def add(attri)
    subtree = Tree.new()
    @attribute << attri
    @children << subtree
    return subtree
  end
end

def traverse(x, sp)
  sp.times { print " " }
  if x.flag != nil
    print x.flag
    print "\n"
    return
  end
  print x.atindex
  print "\n"
  both(x.attribute, x.children) do |a, c|
    (sp + 2).times { print " " }
    print a
    print "\n"
    traverse(c, sp + 2)
  end
end

def calen(x)
  num = x.inject(0) { |num, i| $label[i] ? num + 1 : num }
  rate = num.to_f / x.length
  rate = 0.000001 if num == 0
  rate = 0.999999 if num == x.length
  -(rate) * Math.log2(rate) - (1 - rate) * Math.log2(1 - rate)
end

def id3(example, attri, node)
  n = example.inject(0) { |n, i| $label[i] ? n + 1 : n }
  node.flag = true if n == example.length
  node.flag = false if n == 0
  node.flag = (n > example.length / 2 ? true : false) if attri.empty?
  if node.flag == nil
    node.entropy = calen(example)
    maxgain, maxid = nil, nil
    attri.each do |i|
      h = {}
      example.each do |j|
        if h.key?($data[j][i])
          h[$data[j][i]] << j
        else
          h[$data[j][i]] = [j]
        end
      end
      gain = node.entropy
      h.each_value { |v| gain -= calen(v) * v.length / example.length }
      if maxgain == nil || gain > maxgain
        maxgain = gain
        maxid = i
      end
    end
    h = {}
    example.each do |j|
      if h.key?($data[j][maxid])
        h[$data[j][maxid]] << j
      else
        h[$data[j][maxid]] = [j]
      end
    end
    $data.each { |d| h[d[maxid]] = [] unless h.key?(d[maxid]) }
    node.atindex = maxid
    h.each do |k, v|
      if v.empty?
        ch = node.add(k)
        ch.flag = (n > example.length / 2 ? true : false)
      else
        ch = node.add(k)
        id3(v, attri - [maxid], ch)
      end
    end
  end
end

t = Tree.new()
set_ex = Array.new($data.length) { |i| i }
set_at = Array.new($data[0].length) { |i| i }
id3(set_ex, set_at, t)
traverse(t, 0)
