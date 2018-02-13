require "./ms-apriori-utilities"

$count = @support_count
$mis = $misHash
$n = $transactions.length

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
        if (x[0] == frequent_set[i][0]) && (x[0] == frequent_set[j][0])
          i_last = frequent_set[i].last
          j_last = frequent_set[j].last
          if x.length == frequent_set[i].length-1 and i_last != j_last
            support_i = $count[i_last].fdiv($n)
            support_j = $count[j_last].fdiv($n)
            if i_last < j_last and (support_i - support_j).abs <= sdc
              x.push(i_last)
              x.push(j_last)
              ck.push(x)
              (0..x.length-1).step(1) do |i|
                s = x[0..x.length]
                s.delete(x[i])
                if s.include? x[0] or ($mis[x[1]] == $mis[x[0]])
                  if not frequent_set.include? s
                    ck.delete(x)
                  end
                end
              end
            end
          end
        end
      end
      j += 1
    end
    i += 1
  end
  ck
end


#c = level2_candidate_generation(list, 0.1)
#ck = MS_candidate_generation(freq,0.1)
#print ck