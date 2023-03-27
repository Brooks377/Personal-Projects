def cumulative_values(lst):
    cum_sum = 0
    cum_lst = []
    for val in lst:
        cum_sum += val
        cum_lst.append(cum_sum)
    return cum_lst