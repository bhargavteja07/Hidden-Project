require "./ms-apriori-utilities"
require "./data_extraction"
require "./candidate_generation"


def ms_apriori
  @output = ""
  transactions = $transactions
  sorted_item_list = sort_items_with_mis(transactions)
  list_L = init_pass(sorted_item_list, transactions)
  freq_one_item = freq_one_item_sets(transactions)
  @output += "Frequent 1-itemsets\n\n"
    for x in freq_one_item
      @output += "     #{@support_count[x]} : {#{x}}\n"
    end
    @output += "     Total number of frequent 1-itemsets = #{freq_one_item.length}\n\n"
  curr_freq_set = freq_one_item
  @global_freq_set = []
  @global_freq_set.push(curr_freq_set)
  @support_count_freq_items = {}
  k = 2
  while curr_freq_set.length > 0
    if k == 2
      curr_candidate_k = level2_candidate_generation(list_L, $sdc)
    else
      curr_candidate_k = MS_candidate_generation(curr_freq_set,$sdc)
    end

    @support_count_freq_items = freq_item_generation(curr_candidate_k)
    curr_freq_set = fk_generation(curr_candidate_k)
    print(curr_freq_set)
    print("\n")

    @global_freq_set.push(curr_freq_set)
    if curr_freq_set.length > 0
      @output += "Frequent #{k}-itemsets\n\n"
    end
    for x in curr_freq_set
      @output += "     #{@support_count_freq_items[x]} : {"
      for y in x
        @output += "#{y},"
      end
      @output = @output[0..-2]
      @output += "}\n"
      @output += "Tailcount = #{@candidate_count[x[1..-1]]}\n"
    end
    if curr_freq_set.length > 0
      @output += "\n     Total number of frequent #{k}-itemsets = #{curr_freq_set.length}\n\n"
    end
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
@output += "...."


File.open("output.txt", 'w') { |file| file.write(@output) }
