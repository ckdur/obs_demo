import pya
import re
import os, sys
import importlib
current = os.path.dirname(os.path.realpath(__file__))
root_dir = os.getenv('ROOT_DIR')
sys.path.insert(0, current)
sys.path.insert(0, root_dir + "/lib")
import verilog_parser as vlog

# Arguments
## For the purpose of this program
# infile = GDS file
# invfile = Verilog file to input
# outxmlfile = XML file to output
# toplist = Cell top list
# techname = The technology name. A "{techname}_settings.py will be imported"
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

# Get the max LVL 
maxlvl = int(levels)
print("The maxlvl is {}".format(maxlvl))

# Extract the actual list
with open(toplist, 'r') as fh:
  toplst = fh.read().split()

# Parse the verilog
with open(invfile, 'rt') as fh:
  code = fh.read()
vlog_ex = vlog.VerilogExtractor()
vlog_mods = vlog_ex.extract_objects_from_source(code)

# Open the xml file as write
fo = open(outxmlfile, "w")
fo.write("<?xml version='1.0' encoding='UTF-8'?>\n")
fo.write("<gate-library>\n")
fo.write(" <gate-templates>\n")

idx = 2
type_id = 2
for top in toplst:
  print("Processing {}".format(top))
  # Extract ports
  mod = None
  for m in vlog_mods:
    if m.name == top: # Only in this top
      mod = m
      break
  else:
    print("Not found in verilog: {}".format(top))

  # Put the layout TOP that we want to see
  for i in range(0, lv.cellviews()):
    layout = lv.cellview(i).layout()
    try: 
      for cell in layout.each_cell():
        if cell.name == top:
          lv.select_cell(cell.cell_index(), lv.active_cellview_index())
          thislayout = cell.layout()
          raise StopIteration
    except:
      break
  else:
    raise StopIteration
  
  # Find the metal_pin id, and also the shapes
  for boundli in thislayout.layer_indices():
    lp = thislayout.get_info(boundli)
    # print("Layer: {}, datatype={}".format(lp.layer, lp.datatype))
    if lp.layer == cfg.boundarygds[0] and lp.datatype == cfg.boundarygds[1]:
      break
  else:
    print("Not found the boundary")
    raise StopIteration
  
  # Find the metal_pin id, and also the shapes
  for li in thislayout.layer_indices():
    lp = thislayout.get_info(li)
    if lp.layer == cfg.metal_pin[0] and lp.datatype == cfg.metal_pin[1]:
      break
  else:
    print("Not found the metal pin")
    raise StopIteration
  
  # Get the boundary and calculate the actual size of the png in pixels
  box = cell.dbbox() # NOTE: The dbbox cannot be extracted like this, but is put here as backup
  si = cell.begin_shapes_rec(boundli)
  while not si.at_end():
    shape = si.shape()
    if not shape.is_text():
      box = shape.dbbox()
      break
    si.next()
  print("Detected boundary box {}".format(box))
  # As for the boundary top and bottom, we just need to substract the fixed values
  box.bottom = box.bottom + cfg.size_power[0]
  box.top = box.top - cfg.size_power[1]
  # Now, for left and right, we need to look to all shapes, specifically not texts
  minx = box.right
  maxx = box.left
  for ali in thislayout.layer_indices():
    lp = thislayout.get_info(ali)
    if (lp.layer == cfg.metal_drw[0] and lp.datatype == cfg.metal_drw[1]) or (lp.layer == cfg.diff_drw[0] and lp.datatype == cfg.diff_drw[1]):
      si = cell.begin_shapes_rec(ali)
      while not si.at_end():
        shape = si.shape()
        if not shape.is_text():
          thisbox = shape.dbbox()
          # If thisbox is within the limits of the boundary, we use it
          if (box.left + cfg.grid) < thisbox.left and thisbox.left < (box.right - cfg.grid):
            minx = min(minx, thisbox.left)
          if (box.left + cfg.grid) < thisbox.right and thisbox.right < (box.right - cfg.grid):
            maxx = max(maxx, thisbox.right)
        si.next()
  box.left = minx - cfg.ext_sides[0]
  box.right = maxx + cfg.ext_sides[0]
  print("Detected box {}".format(box))
  widthd = box.width() * cfg.pxpermicron
  heightd = box.height() * cfg.pxpermicron
  width = int (widthd)
  height = int (heightd)

  # Find the ports in a dict
  port_dict = {}
  if mod:
    for p in mod.ports:
      # Find any label, and extract x and y
      x = 0.0
      y = 0.0
      si = cell.begin_shapes_rec(li)
      while not si.at_end():
        shape = si.shape()
        if shape.is_text():
          if shape.text_string == p.name:
            pos = shape.text_dpos
            x = (pos.x - box.left) / box.width() * widthd
            y = (box.top - pos.y) / box.height() * heightd
        si.next()
      # Extract the direction from the verilog
      typ = "inout"
      if p.mode == "input":
        typ = "in"
      elif p.mode == "output":
        typ = "out"
      # create the dict for the xml output
      port_dict[p.name] = {"x":x, "y":y, "fill-color":"#FF0000FF", "description":"", "type":typ, "id":idx}
      idx = idx + 2

  # Export everything
  outfile = libout + "/" + top + ".full.png"
  outtranfile = libout + "/" + top + ".tran.png"
  outmetfile = libout + "/" + top + ".metal.png"

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

  for layer in lv.each_layer():
    layer.visible = True
  
  last = top.split("_")[-1]
  if last.isnumeric():
    lvl = int(last)
    if lvl >= maxlvl:
      continue # Do not put this level in the XML
  
  # Export the gate in the xml
  fo.write("  <gate name=\"{}\" logic-class=\"\" fill-color=\"#303030A0\" height=\"{}\" description=\"\" type-id=\"{}\" frame-color=\"#D9B032A0\" width=\"{}\">\n".format(top, heightd, type_id, width))
  type_id = type_id + 2
  fo.write("   <images>\n")
  fo.write("    <image image=\"{}_metal.jpg\" layer-type=\"metal\"/>\n".format(top))
  fo.write("    <image image=\"{}_logic.jpg\" layer-type=\"logic\"/>\n".format(top))
  fo.write("    <image image=\"{}_tran.jpg\" layer-type=\"transistor\"/>\n".format(top))
  fo.write("   </images>\n")
  fo.write("   <ports>\n")
  for k, v in port_dict.items():
    fo.write("    <port name=\"{}\"".format(k))
    for sk, sv in v.items():
      fo.write(" {}=\"{}\"".format(sk, sv))
    fo.write("/>\n")
  fo.write("   </ports>\n")
  fo.write("   <implementations>\n")
  fo.write("   </implementations>\n")
  fo.write("  </gate>\n")

fo.write(" </gate-templates>\n")
fo.write("</gate-library>\n")
fo.close()

