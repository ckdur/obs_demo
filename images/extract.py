import pya
import xml.etree.ElementTree as ET
import os, sys, importlib

# Arguments
## For the purpose of this program
# top = The TOP
# infile = GDS file
# inxmlfile = GDS file
# outpngfile = PNG file
# outgdsfile = GDS out file

current = os.path.dirname(os.path.realpath(__file__))
root_dir = os.getenv('ROOT_DIR')
sys.path.insert(0, current)
sys.path.insert(0, root_dir + "/lib")

cfg = importlib.import_module("{}_settings".format(techname))

# Initialize basics
app = pya.Application.instance()
mw = app.main_window()

# Create a view, then get the reference
lvi = mw.create_view()
lv = mw.view(lvi)

# Load the layout
lv.load_layout(infile, 0)

# Parse the XML of the library
tree = ET.parse(inxmllib)
root = tree.getroot()
lib = {}
for glibrary in root.iter("gate-library"):
  for gtemplates in glibrary.iter("gate-templates"):
    for gate in gtemplates.iter("gate"):
      lib[gate.attrib["type-id"]] = {"name":gate.attrib["name"], "found":[], "notfound": []}

# Put the layout TOP that we want to see
for i in range(0, lv.cellviews()):
  layout = lv.cellview(i).layout()
  try: 
    for cell in layout.each_cell():
      print(cell.name, top)
      if cell.name == top:
        lv.select_cell(cell.cell_index(), lv.active_cellview_index())
        raise StopIteration
  except:
    break
else:
  raise StopIteration
layout = cell.layout()
detected = layout.insert_layer(pya.LayerInfo(255, 0))
notdetected = layout.insert_layer(pya.LayerInfo(254, 0))
wrong = layout.insert_layer(pya.LayerInfo(253, 0))

# Extract the cell box, and the width and height in degate / image sizes
if 'dispw' in globals() and 'disph' in globals() and 'dispx' in globals() and 'dispy' in globals():
  box = pya.Box(float(dispx), float(dispy), float(dispx)+float(dispw), float(dispy)+float(disph))
elif 'dispw' in globals() and 'disph' in globals():
  box = pya.Box(0, 0, float(dispw), float(disph))
else:
  box = cell.dbbox()
widthd = box.width() * cfg.pxpermicron
heightd = box.height() * cfg.pxpermicron
width = int (widthd)
height = int (heightd)

# Define the function for searching the most-area
def search_most_area(l1,gbox):
  for p_inst in l1.each_inst():
    p_cell = p_inst.cell
    ibox = p_inst.dbbox()
    inbox = ibox & gbox
    if not inbox.empty():
      per = inbox.area() / gbox.area() * 100
      yield (p_cell.name, per, inbox)
      #print("Found {} with {}%".format(p_cell.name, per))

# define the function for extracting all instances of a instance name
def extract_insts(l1, names):
  for p_inst in l1.each_inst():
    p_cell = p_inst.cell
    if p_cell.name in names:
      yield p_inst.dbbox()

# Define a function for filtering the boxes that intersect in a list of other boxes
# if insts[i] have at least 1 
def filter_non_intersect(insts, found):
  for inst in insts:
    for f in found:
      inbox = inst & f[2] # Do the intersection
      if not inbox.empty():
        per = inbox.area() / inst.area() * 100
        if per > 50: # More than 50% covered
          break
    else:
      yield inst

def filter_inside(insts, container):
  for inst in insts:
    if inst.inside(container):
      yield inst


# Parse the detected XML
print("Parsing XML and evaluating 'found, detected and wrong'")
n_detected = 0
n_wrong = 0
n_notdetected = 0
tree = ET.parse(inxmlfile)
root = tree.getroot()
for model in root.iter("logic-model"):
  for gates in model.iter("gates"):
    for gate in gates.iter("gate"):
      # Get the box of this detected gate
      left = float(gate.attrib["min-x"]) / cfg.pxpermicron + box.left
      right = float(gate.attrib["max-x"]) / cfg.pxpermicron + box.left
      bottom = box.top - float(gate.attrib["min-y"]) / cfg.pxpermicron
      topd = box.top - float(gate.attrib["max-y"]) / cfg.pxpermicron
      gbox = pya.DBox(left, bottom, right, topd)
      # Search the intersected instances
      inboxes = sorted(list(search_most_area(cell, gbox)), key=lambda x: x[1], reverse=True)
      libid = gate.attrib["type-id"]
      # If there are instances, we append them in found
      if len(inboxes) > 0:
        lib[libid]["found"].append(inboxes[0])
        print(lib[libid]["name"], inboxes[0])
        if lib[libid]["name"] == inboxes[0][0]:
          cell.shapes(detected).insert(inboxes[0][2])
          n_detected = n_detected + 1
        else:
          cell.shapes(wrong).insert(inboxes[0][2])
          n_wrong = n_wrong + 1
      else:
        print(lib[libid]["name"], "No instances")

all_insts = [p_inst.dbbox() for p_inst in cell.each_inst()]
insts = list(filter_inside(all_insts, pya.DBox(box)))

# Find the non-detected
print("Finding the non-detected")

bound_to_degate_lib = False
if not bound_to_degate_lib:
  all_found = []
  for k, v in lib.items():
    all_found.extend(v["found"])
  fints = list(filter_non_intersect(insts, all_found))
  for fint in fints:
      cell.shapes(notdetected).insert(fint)
      n_notdetected = n_notdetected + 1
else:
  for k, v in lib.items():
    all_insts = list(extract_insts(cell, v["name"]))
    insts = list(filter_inside(all_insts, pya.DBox(box)))
    # print(v["name"], insts)
    fints = list(filter_non_intersect(insts, v["found"]))
    for fint in fints:
      print("{} not recognized: {}".format(v["name"], fint))
      cell.shapes(notdetected).insert(fint)
      n_notdetected = n_notdetected + 1

n_all_insts = len(insts)

# Do zoom box and save image
lv.load_layer_props("degate_detect.lyp")
lv.zoom_box(box)
lv.save_image(outpngfile, width, height)
layout.write(outgdsfile)

p_detected = n_detected / n_all_insts * 100
p_wrong = n_wrong / n_all_insts * 100
p_notdetected = n_notdetected / n_all_insts * 100
if "output_stat" in globals():
  with open(output_stat, "w") as f:
    f.write("Statistics\n")
    f.write("  detected = {}/{} ({:.3}%)\n".format(n_detected, n_all_insts, p_detected))
    f.write("  wrong = {}/{} ({:.3}%)\n".format(n_wrong, n_all_insts, p_wrong))
    f.write("  not detected = {}/{} ({:.3}%)\n".format(n_notdetected, n_all_insts, p_notdetected))

print("Statistics")
print("  detected = {}/{} ({:.3}%)".format(n_detected, n_all_insts, p_detected))
print("  wrong = {}/{} ({:.3}%)".format(n_wrong, n_all_insts, p_wrong))
print("  not detected = {}/{} ({:.3}%)".format(n_notdetected, n_all_insts, p_notdetected))


