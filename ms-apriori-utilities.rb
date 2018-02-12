require "./data_extraction"

$transactions = parse_input_file("input-data.txt")
$itemSet, $misHash = parse_parameter_file("parameter-file.txt")

def sort_items_with_mis(transactions)
  @item_list = $misHash.keys
  sorted_item_list = @item_list.sort {|a,b| $misHash[a] <=> $misHash[b]}
  return sorted_item_list
end

def init_pass(sorted_item_list, transactions)
  @support_count = Hash.new 0
  no_of_transactions = transactions.length

  for item_set in transactions
    item_set.each do |item|
      @support_count[item.to_i] += 1
    end
  end

  @init_pass_list = []

  for i in 0..sorted_item_list.length
    puts
    if (@support_count[sorted_item_list[i]].fdiv(no_of_transactions)) >= $misHash[sorted_item_list[i]]
      @init_pass_list.push(sorted_item_list[i])
      break
    end
  end

  for j in i+1..sorted_item_list.length

    if (@support_count[sorted_item_list[j]].fdiv(no_of_transactions)) >= $misHash[sorted_item_list[i]]
      @init_pass_list.push(sorted_item_list[j])
    end
  end

  return @init_pass_list
end

def freq_one_item_sets(transactions)
  no_of_transactions = transactions.length
  freq_one_item = []
  for l in @init_pass_list
    if (@support_count[l].fdiv(no_of_transactions)) >= $misHash[l]
      freq_one_item.push(l)
    end
  end
  if( (freq_one_item & $must_have).length >= 1)
    return freq_one_item
  end

  return []
end

def support_of(item)
  return @support_count[item].fdiv($transactions.length)
end

def support_count_of(item)
  return @support_count[item]
end

def does_match_unique_last_item_constraint(freq_set_one, freq_set_two)
  freq_set_len = freq_set_one.length
  for i in 0..freq_set_len
    if i == freq_set_len-1
      if freq_set_one[i] == freq_set_two[i]
        return false
      end
    else
      if freq_set_one[i] != freq_set_two[i]
        return false
      end
    end
  end
  return true
end


def is_contained_in_transactions(candidate,transaction)

  if (candidate - transaction).length == 0
    return true
  end
  return false
end

def does_contain_required(item_set)
  if((item_set & $must_have).length >= 1)
    return true
  end
  return false
end

def does_contain_invalid(item_set)
  if (item_set - $cannot_be_together).length == 0
    return true
  end
  return false
end

def freq_item_generation(candidate_set)

  @candidate_count = Hash.new 0

  for transaction in $transactions
    for candidate in candidate_set
      if is_contained_in_transactions(candidate,transaction)
        @candidate_count[candidate] += 1
      end
      if is_contained_in_transactions(candidate.drop(1),transaction)
        @candidate_count[candidate.drop(1)] += 1
      end
    end
  end
  puts @candidate_count
end

=begin
def multiple_support_candidate_generation(freq_item_set)
  freq_set_len = freq_set_one.length
  for f1 in freq_item_set
    for f2 in freq_set_len[i+1..freq_set_len]
      if(f1[-1] < f2[-1] and (support_of(f1[-1]) - support_of(f2[-1])) < $sdc)
      end
    end
  end
end
=end

sorted_mis_list = sort_items_with_mis($transactions)
init_pass(sorted_mis_list, $transactions)
freq_one_item_sets($transactions)
#puts does_match_unique_last_item_constraint([10,20],[20,30])
puts [[10,20]] - [[10,20,30],[20,30]]

#freq_item_generation([[100,140]])