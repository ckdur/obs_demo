import sys
import random

if len(sys.argv) < 4:
  print("USAGE: {} [filein.v] [fileout.v] [levels]".format(sys.argv[0]))

file1 = open(sys.argv[1], 'r')
Lines = file1.readlines()

file2 = open(sys.argv[2], 'w')

levels = int(sys.argv[3])

cell_matrix = [["BUFFD1", "BUFFD1_1"],
["AN2D1", "AN2D1_1", "AN2D1_2", "AN2D1_3"],
["AO21D1", "AO21D1_1", "AO21D1_2", "AO21D1_3"],
["OA21D1", "OA21D1_1", "OA21D1_2", "OA21D1_3"],
["AOI21D1", "AOI21D1_1", "AOI21D1_2", "AOI21D1_3"],
["OAI21D1", "OAI21D1_1", "OAI21D1_2", "OAI21D1_3"],
["DFCNQD1", "DFCNQD1_1", "DFCNQD1_2", "DFCNQD1_3"],
["DFQD1", "DFQD1_1", "DFQD1_2", "DFQD1_3"],
["LNQD1", "LNQD1_1", "LNQD1_2", "LNQD1_3"],
["ND2D1", "ND2D1_1", "ND2D1_2", "ND2D1_3"],
["NR2D1", "NR2D1_1", "NR2D1_2", "NR2D1_3"],
["OR2D1", "OR2D1_1", "OR2D1_2", "OR2D1_3"],
["MUX2D1", "MUX2D1_1", "MUX2D1_2", "MUX2D1_3"]]
count = 0
# Strips the newline character
for line in Lines:
    splt = line.split(" ")
    wline = line
    try:
      for item in splt:
        for cells_all in cell_matrix:
          cells = cells_all[:min(len(cells_all), levels)]
          if item in cells_all and len(item):
            raise StopIteration
    except StopIteration:
      # Means it was found for this item. Replace it
      # We are assuming only 1 occurence
      item_rpl = random.choice(cells)
      wline = line.replace(item, item_rpl)
    file2.write(wline)
    
file1.close()
file2.close()

