import pya
import os, sys, importlib

current = os.path.dirname(os.path.realpath(__file__))
root_dir = os.getenv('ROOT_DIR')
sys.path.insert(0, current)
sys.path.insert(0, root_dir + "/lib")

cfg = importlib.import_module("{}_settings".format(techname))

# Initialize basics
app = pya.Application.instance()
app.set_config("background-color", "#000000")
app.set_config("grid-visible", "false")
app.set_config("text-visible", "false")
mw = app.main_window()

# Create a view, then get the reference
lvi = mw.create_view()
lv = mw.view(lvi)

# Load the layer props and the layout
lv.load_layout(infile, 0)
lv.load_layer_props("{}/lib/{}_real.lyp".format(root_dir, techname))

# Put the layout TOP that we want to see
for i in range(0, lv.cellviews()):
  layout = lv.cellview(i).layout()
  try: 
    for cell in layout.each_cell():
      if cell.name == top:
        #lv.select_cell(cell.cell_index(), lv.active_cellview_index())
        lv.select_cell(cell.cell_index(), i)
        raise StopIteration
  except:
    break
else:
  raise StopIteration

# Get the boundary and calculate the actual size of the png in pixels
if 'dispw' in globals() and 'disph' in globals() and 'dispx' in globals() and 'dispy' in globals():
  box = pya.Box(float(dispx), float(dispy), float(dispx)+float(dispw), float(dispy)+float(disph))
elif 'dispw' in globals() and 'disph' in globals():
  box = pya.Box(0, 0, float(dispw), float(disph))
else:
  box = cell.dbbox()

width = int (box.width() * cfg.pxpermicron)
height = int (box.height() * cfg.pxpermicron)

# Do zoom box and save image
lv.zoom_box(box)
lv.save_image(outfile, width, height)

# Put the metal and cont layers only
for layer in lv.each_layer():
  layer.visible = layer.name in cfg.diff_poly_names and len(layer.name) != 0
lv.save_image(outtranfile, width, height)

# Put the metal and cont layers only
for layer in lv.each_layer():
  layer.visible = layer.name in cfg.metal_cont_names and len(layer.name) != 0
lv.save_image(outmetfile, width, height)


