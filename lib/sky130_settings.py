#!/usr/bin/env python

# Constraints
pxpermicron = 30 # Pixeles per micron
metal_cont_names = ["li1.drawing - 67/20", "licon1.drawing - 66/44"] # Name (in .lyp). This will be displayed on metal captures
diff_poly_names = ["diff.drawing - 65/20", "poly.drawing - 66/20"] # Name (in .lyp). This will be displayed on metal captures
size_power = [0.36, 0.36] # The size of power in bottom [0] and top [1]
ext_sides = [0.1, 0.1] # The extension from the detected boundary to put the margin
grid = 0.01 # The grid of this tech
metal_pin = [67, 16] # Layer (in GDS) of the metalpin
boundarygds = [235, 4] # Layer (in GDS) of the prboundary
metal_drw = [67, 20] # Layer (in GDS) of the metal
diff_drw = [65, 20] # Layer (in GDS) of the diff

