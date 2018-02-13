require "./ms-apriori-utilities"
require "./data_extraction"
require "./candidate_generation"

def ms_apriori
  transactions = $transactions
  sorted_item_list = sort_items_with_mis(transactions)
  list_L = init_pass(sorted_item_list, transactions)
  freq_one_item = freq_one_item_sets(transactions)
  print freq_one_item
  print "\n"
  curr_freq_set = freq_one_item
  @global_freq_set = []
  @global_freq_set.push(curr_freq_set)
  @support_count_freq_items = {}
  k=2
  while curr_freq_set.length > 0
    if k == 2
      curr_candidate_k = level2_candidate_generation(list_L, $sdc)
    else
      curr_candidate_k = MS_candidate_generation(curr_freq_set,$sdc)
    end
    #print(curr_candidate_k)
    @support_count_freq_items = freq_item_generation(curr_candidate_k)
    curr_freq_set = fk_generation(curr_candidate_k)
    print curr_freq_set
    print "\n"
    @global_freq_set.push(curr_freq_set)
    k += 1
    #curr_freq_set = []
  end
end

def fk_generation(candidate_k)
  no_of_transactions = $transactions.length
  freq_item_set = []
  for c in candidate_k
    if (@support_count_freq_items[c].fdiv(no_of_transactions)) >= $misHash[c[0]] and (c - $must_have).length != c.length and does_contain_invalid(c) == false
      freq_item_set.push(c)
    end
  end
  return freq_item_set

end

ms_apriori

