import pya
import importlib
import os, sys
current = os.path.dirname(os.path.realpath(__file__))
root_dir = os.getenv('ROOT_DIR')
sys.path.insert(0, current)
sys.path.insert(0, root_dir + "/lib")
cfg = importlib.import_module("{}_settings".format(techname))

# Initialize basics
app = pya.Application.instance()
app.set_config("background-color", "#FFFFFF")
app.set_config("grid-visible", "false")
app.set_config("text-visible", "false")
mw = app.main_window()

# Create a view, then get the reference
lvi = mw.create_view()
lv = mw.view(lvi)

# Load the layer props and the layout
lv.load_layout(infile, 0)
lv.load_layer_props("{}/lib/{}_toon.lyp".format(root_dir, techname))

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

if 'hideLayers' in globals():
  layernames = hideLayers.split(",")
  li = lv.begin_layers()
  while not li.at_end():
    lp = li.current()
    if lp.name in layernames:
      lp.visible = False
    lp = li.next()

if 'dispw' in globals() and 'disph' in globals() and 'dispx' in globals() and 'dispy' in globals():
  box = pya.Box(float(dispx), float(dispy), float(dispx)+float(dispw), float(dispy)+float(disph))
elif 'dispw' in globals() and 'disph' in globals():
  box = pya.Box(0, 0, float(dispw), float(disph))
else:
  box = cell.dbbox()

if 'desiredHeight' in globals():
  pxpermicron = float(desiredHeight)/box.height()
else:
  pxpermicron = cfg.pxpermicron

width = int (box.width() * pxpermicron)
height = int (box.height() * pxpermicron)

# Do zoom box and save image
if 'outfile' in globals():
  lv.zoom_box(box)
  lv.save_image(outfile, width, height)

if 'outdxffile' in globals():
  opt = pya.SaveLayoutOptions()
  opt.format = "DXF"
  opt.select_cell(cell.cell_index())
  opt.keep_instances=True
  layout = cell.layout()
  layout.write(outdxffile, opt)

