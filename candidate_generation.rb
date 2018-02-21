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
  #print "c2 length #{c2.length} \n"
  #print  "#{$count[4].fdiv($n)} ----- #{$count[19].fdiv($n)}"
  c2
end


def MS_candidate_generation(frequent_set, sdc)
  ck = []
  len = frequent_set.length
  i = 0
  while i < len
    j = i+1
    while j < len
      if i != j
        x = frequent_set[i] & frequent_set[j]

        if ((frequent_set[i][0..-2] & frequent_set[j][0..-2]) == frequent_set[i][0..-2])

          i_last = frequent_set[i].last
          j_last = frequent_set[j].last
          if i_last != j_last
            support_i = $count[i_last].fdiv($n)
            support_j = $count[j_last].fdiv($n)
            if (support_i - support_j).abs <= sdc
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

  #print "ck length #{ck.length} \n"
  ck
end


#c = level2_candidate_generation(list, 0.1)
#print MS_candidate_generation([[26, 33], [26, 5], [26, 19], [26, 32], [26, 40], [26, 43], [26, 23], [26, 4], [26, 10], [26, 11], [26, 47], [26, 2], [26, 16], [26, 28], [26, 39], [26, 17], [26, 46], [26, 37], [26, 6], [33, 50], [33, 5], [33, 8], [33, 19], [33, 32], [33, 40], [33, 43], [33, 22], [33, 23], [33, 4], [33, 10], [33, 11], [33, 47], [33, 2], [33, 16], [33, 28], [33, 39], [33, 17], [33, 46], [33, 37], [33, 6], [50, 19], [50, 43], [50, 10], [50, 2], [50, 28], [50, 37], [50, 6], [5, 43], [5, 17], [8, 43], [8, 17], [8, 6], [19, 32], [19, 40], [19, 43], [19, 23], [19, 4], [19, 10], [19, 11], [19, 47], [19, 2], [19, 16], [19, 28], [19, 39], [19, 17], [19, 46], [19, 37], [19, 6], [32, 43], [32, 23], [32, 28], [32, 17], [32, 37], [32, 6], [40, 43], [40, 28], [40, 17], [40, 37], [40, 6], [43, 23], [43, 4], [43, 10], [43, 11], [43, 47], [43, 2], [43, 16], [43, 28], [43, 39], [43, 17], [43, 46], [43, 37], [43, 6], [23, 17], [23, 6]],0.1)
#print ck