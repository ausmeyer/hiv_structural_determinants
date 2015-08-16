import numpy as np
import sys
from Bio import SeqIO

def calculate_identity(filename, outfile):
    all_identities = []
    ob = list(SeqIO.parse(open(filename, 'r'), 'fasta'))
    length = float(len(ob[0].seq))
    for i, seq1 in enumerate(ob):
        for j in range(i + 1, len(ob)):
            seq2 = ob[j]
            all_identities.append(sum(aa1 == aa2 for aa1, aa2, in zip(seq1.seq, seq2.seq))/length)
        print(i),
        sys.stdout.flush()
    print('\n\n' + str(np.mean(all_identities)))

    open(outfile, 'w').write(str(np.mean(all_identities)))

def main():
    calculate_identity(sys.argv[1], sys.argv[2])

if __name__ == "__main__":
    main()
