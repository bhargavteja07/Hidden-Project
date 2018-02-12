list = [100,140,70,80,90,120,20,30,50,10]
$count = {}
$count[10] = 2
$count[20] = 6
$count[30] = 3
$count[40] = 0
$count[50] = 2
$count[60] = 0
$count[70] = 3
$count[80] = 6
$count[90] = 2
$count[100] = 1
$count[120] = 1
$count[140] = 1
$n = 6
$mis = {}
$mis[10] = 0.43
$mis[20] = 0.3
$mis[30] = 0.3
$mis[40] = 0.4
$mis[50] = 0.4
$mis[60] = 0.3
$mis[70] = 0.2
$mis[80] = 0.2
$mis[90] = 0.2
$mis[100] = 0.1
$mis[120] = 0.2
$mis[140] = 0.15

def level2_candidate_generation(list, sdc)
  c2 = []
  list.each_with_index do |l, l_index|
    support_l = $count[l].fdiv($n)
    if support_l >= $mis[l]
      list.each_with_index do |h, h_index|
        if h_index > l_index
          support_h = $count[h].fdiv($n)
          if support_h >= $mis[l] and (support_h - support_l).abs <= sdc
            c2.push([l,h])
          end
        end
      end
    end
  end
  c2

end

def MS_candidate_generation(frequent_set, sdc)
  ck = []
  len = frequent_set.length
  i = 0
  while i < len
    j = 0
    while j < len
      if i != j
        x = frequent_set[i] & frequent_set[j]
        i_last = frequent_set[i].last
        j_last = frequent_set[j].last
        if x.length == len-1 and i_last != j_last
          support_i = $count[i_last].fdiv($n)
          support_j = $count[j_last].fdiv($n)
          if i_last < j_last and (support_i - support_j).abs <= sdc
            x.push(i_last)
            x.push(j_last)
            ck.push(c)
          end
        end
      end
    end
  end
end

c = level2_candidate_generation(list, 0.1)
print c