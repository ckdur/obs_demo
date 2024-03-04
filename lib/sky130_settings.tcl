set ROOT_DIR $env(ROOT_DIR)
set LIB_PATHS "$ROOT_DIR"
set LIBS "${ROOT_DIR}/lib/sky130.lib"
set LEFS "${ROOT_DIR}/lib/sky130.tlef ${ROOT_DIR}/lib/sky130.lef"
set GDSS "${ROOT_DIR}/lib/sky130.gds"

# TODO: Do the characterization of the lib
set LIBS_BC "${ROOT_DIR}/lib/sky130.lib"
set LIBS_WC "${ROOT_DIR}/lib/sky130.lib"

if { [info exists ::env(PDK_ROOT)]} {
  # Setting a default
  set PDK_ROOT $::env(PDK_ROOT)
} else {
  # Setting a default
  set PDK_ROOT "/opt/OpenLane/share/pdk"
}
set RCX_RULES "$PDK_ROOT/sky130A/libs.tech/openlane/rules.openrcx.sky130A.nom.calibre"
