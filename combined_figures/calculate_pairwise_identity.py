for i, seq1 in enumerate(ob):
    for j, seq2 in enumerate(ob):
        if i <= j:
            continue
        else:
            all_identities.append(100.00 * sum(aa1 == aa2 for aa1, aa2, in zip(seq1, seq2))/float(len(seq1)))
    print(i)
    print(np.mean(all_identities))
