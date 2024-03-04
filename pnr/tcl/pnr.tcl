##############################################################################
## Preset global variables and attributes
##############################################################################
set TOP $env(TOP)
set SYN_DIR $env(SYN_DIR)
set SYN_SRC $env(SYN_SRC)
set PNR_DIR $env(PNR_DIR)
set PX $env(PX)
set PY $env(PY)
set PR $env(PR)
set X $env(X)
set Y $env(Y)

###############################################################
## Library setup
###############################################################
source $env(ROOT_DIR)/lib/$env(TECH)_settings.tcl

# We assume the first LIB is the standard cell lib
set LIBMAIN [lindex $LIBS 0]
set LIBBCMAIN [lindex $LIBS_BC 0]
set LIBWCMAIN [lindex $LIBS_WC 0]

# TODO: Figure out what is the actual set of commands work
define_corners typ
read_liberty -corner typ "$LIBMAIN"
read_liberty -min -corner typ "$LIBBCMAIN"
read_liberty -max -corner typ "$LIBWCMAIN"

# We assume the first LEF is the tech lef
set TECHLEF [lindex $LEFS 0]
set OTHERLEF [lrange $LEFS 1 end]

read_lef -tech $TECHLEF
foreach LEFFILE $OTHERLEF {
  read_lef "$LEFFILE"
}

read_verilog $SYN_DIR/${TOP}_net.v
link_design ${TOP}

read_sdc $SYN_DIR/tcl/rtl.sdc.tcl

unset_propagated_clock [all_clocks]

if {![file exists outputs]} {
  file mkdir outputs
  puts "Creating directory outputs"
}
if {![file exists reports]} {
  file mkdir reports
  puts "Creating directory reports"
}

####################################
## Cells declaration
####################################

set BUFCells [list BUFFD1]
set INVCells [list INVD1]
# TODO
set FILLERCells [list ]
set DCAPCells [list ]
set DIODECells [list ]

####################################
## Floor Plan
####################################
# TODO: Is there a way to extract from a command?
set row   5.04
set track 0.64
set pitch [expr 32*$row]
set margin [expr 3*$row]

if {[file exists $env(PNR_DIR)/$env(TOP).openlane.fp.tcl]} {
  # FORMAT: initialize_floorplan [-utilization util] [-aspect_ratio ratio] [-core_space space | {bottom top left right}] [-die_area {lx ly ux uy}] [-core_area {lx ly ux uy}] [-sites site_name]
  source $env(PNR_DIR)/$env(TOP).openlane.fp.tcl
} else {
  initialize_floorplan -site obssite -aspect_ratio [expr $PX/$PY] -utilization [expr $PR*100] -core_space "$margin $margin $margin $margin"
}

add_global_connection -net VDD -inst_pattern .* -pin_pattern VDD -power
add_global_connection -net VSS -inst_pattern .* -pin_pattern VSS -power
set_voltage_domain -name CORE -power VDD -ground VSS

insert_tiecells "TIEL/zn" -prefix "TIE_ZERO_"
insert_tiecells "TIEH/z" -prefix "TIE_ONE_"

set ::chip [[::ord::get_db] getChip]
set ::tech [[::ord::get_db] getTech]
set ::block [$::chip getBlock]

set die_area [$::block getDieArea]
set core_area [$::block getCoreArea]

set die_area [list [$die_area xMin] [$die_area yMin] [$die_area xMax] [$die_area yMax]]
set core_area [list [$core_area xMin] [$core_area yMin] [$core_area xMax] [$core_area yMax]]

set dbu [$tech getDbUnitsPerMicron]

set die_coords {}
set core_coords {}

foreach coord $die_area {
    lappend die_coords [expr {1.0 * $coord / $dbu}]
}
foreach coord $core_area {
    lappend core_coords [expr {1.0 * $coord / $dbu}]
}

# write out the floorplan size
set die_width [expr [lindex $die_coords 2] - [lindex $die_coords 0]]
set die_height [expr [lindex $die_coords 3] - [lindex $die_coords 1]]
set core_width [expr [lindex $core_coords 2] - [lindex $core_coords 0]]
set core_height [expr [lindex $core_coords 3] - [lindex $core_coords 1]]

set FPsize   "\{$die_width $die_height\}"
set CoreSize "\{$core_width $core_height\}"
set fo [open FPlanFinal.size w]
puts $fo "Core size: \{X Y\} = ${CoreSize}"
puts $fo "Floorplan size: \{X Y\} = ${FPsize}"
close $fo

# TODO: Ohh my... IS NOT POSSIBLE to get the tracks from tech lef file
#make_tracks {layer} -x_offset {x_offset} -x_pitch {x_pitch} -y_offset {y_offset} -y_pitch {y_pitch}
#li1 X 0.23 0.46
#li1 Y 0.17 0.34
#met1 X 0.17 0.34
#met1 Y 0.17 0.34
#met2 X 0.23 0.46
#met2 Y 0.23 0.46
#met3 X 0.34 0.68
#met3 Y 0.34 0.68
#met4 X 0.46 0.92
#met4 Y 0.46 0.92
#met5 X 1.70 3.40
#met5 Y 1.70 3.40
make_tracks li1 -x_offset 0.23 -x_pitch 0.46 -y_offset 0.17 -y_pitch 0.34
make_tracks met1 -x_offset 0.17 -x_pitch 0.34 -y_offset 0.17 -y_pitch 0.34
make_tracks met2 -x_offset 0.23 -x_pitch 0.46 -y_offset 0.23 -y_pitch 0.46
make_tracks met3 -x_offset 0.34 -x_pitch 0.68 -y_offset 0.34 -y_pitch 0.68
make_tracks met4 -x_offset 0.46 -x_pitch 0.92 -y_offset 0.46 -y_pitch 0.92
make_tracks met5 -x_offset 1.70 -x_pitch 3.40 -y_offset 1.70 -y_pitch 3.40

####################################
## Power planning & SRAMs placement
####################################

define_pdn_grid \
    -name stdcell_grid \
    -starts_with POWER \
    -voltage_domain CORE \
    -pins "met4 met5"

add_pdn_stripe \
    -grid stdcell_grid \
    -layer met4 \
    -width 1.0 \
    -pitch $pitch \
    -offset $pitch \
    -spacing 0.46 \
    -starts_with POWER -extend_to_boundary

add_pdn_stripe \
    -grid stdcell_grid \
    -layer met5 \
    -width 3.2 \
    -pitch $pitch \
    -offset $pitch \
    -spacing 1.6 \
    -starts_with POWER -extend_to_boundary

add_pdn_connect \
    -grid stdcell_grid \
        -layers "met4 met5"

add_pdn_stripe \
        -grid stdcell_grid \
        -layer met1 \
        -width 0.48 \
        -followpins \
        -starts_with POWER

add_pdn_connect \
    -grid stdcell_grid \
        -layers "met1 met4"

add_pdn_ring \
        -grid stdcell_grid \
        -layers "met4 met5" \
        -widths "3.2 3.0" \
        -spacings "0.4 1.6" \
        -core_offset "$row $row"

#define_pdn_grid \
#    -macro \
#    -default \
#    -name macro \
#    -starts_with POWER \
#    -halo "$::env(FP_PDN_HORIZONTAL_HALO) $::env(FP_PDN_VERTICAL_HALO)"

#add_pdn_connect \
#    -grid macro \
#    -layers "$::env(FP_PDN_VERTICAL_LAYER) $::env(FP_PDN_HORIZONTAL_LAYER)"

pdngen

###################################
## Placement
####################################

place_pins -random \
	-random_seed 42 \
	-hor_layers met3 \
	-ver_layers met2

# -density 1.0 -overflow 0.9 -init_density_penalty 0.0001 -initial_place_max_iter 20 -bin_grid_count 64
global_placement -density 0.81

# TODO: Check resize.tcl, as it checks the size of the buffering

# TODO: This is zero in the config.tcl
set cell_pad_value 0
# TODO: Most of the time, diode_pad_value is 2
# set diode_pad_value 2
set cell_pad_side [expr $cell_pad_value / 2]
set_placement_padding -global -right $cell_pad_side -left $cell_pad_side
# set_placement_padding -masters $::env(CELL_PAD_EXCLUDE) -right 0 -left 0
# set_placement_padding -masters $DIODECells -left $diode_pad_value

detailed_placement -max_displacement [subst { "500" "100" }]
optimize_mirroring
if { [catch {check_placement -verbose} errmsg] } {
    puts stderr $errmsg
    exit 1
}
#detailed_placement -disallow_one_site_gaps

####################################
# CTS
####################################
set_routing_layers -signal [subst "met1"]-[subst "met5"] -clock [subst "met3"]-[subst "met5"]

set_global_routing_layer_adjustment * 0.3
set_global_routing_layer_adjustment li1 0.99
set_global_routing_layer_adjustment met1 0
set_global_routing_layer_adjustment met2 0
set_global_routing_layer_adjustment met3 0
set_global_routing_layer_adjustment met4 0
set_global_routing_layer_adjustment met5 0

set_wire_rc -signal -layer "met2"
set_wire_rc -clock -layer "met5"

estimate_parasitics -placement
repair_clock_inverters
configure_cts_characterization -max_cap 1.53169e-12 -max_slew 0.75e-9
clock_tree_synthesis -buf_list $BUFCells -root_buf BUFFD1 -sink_clustering_size 25 -sink_clustering_max_diameter 50 -sink_clustering_enable
set_propagated_clock [all_clocks]

estimate_parasitics -placement

repair_clock_nets -max_wire_length 0

estimate_parasitics -placement

detailed_placement
optimize_mirroring
if { [catch {check_placement -verbose} errmsg] } {
    puts stderr $errmsg
    exit 1
}

report_cts > $PNR_DIR/reports/cts.rpt

###############################################
# Global routing
###############################################
set_propagated_clock [all_clocks]

set_macro_extension 0

global_route -congestion_iterations 50 -verbose -congestion_report_file $PNR_DIR/reports/congestion.rpt

###############################################
# Detail routing
###############################################
set_thread_count 2
detailed_route\
    -bottom_routing_layer "met1" \
    -top_routing_layer "met5" \
    -output_maze $PNR_DIR/reports/${TOP}_maze.log\
    -output_drc $PNR_DIR/reports/${TOP}.drc\
    -droute_end_iter 64 \
    -or_seed 42\
    -verbose 1

#################################################
## Write out final files
#################################################
define_process_corner -ext_model_index 0 X
extract_parasitics -no_merge_via_res -ext_model_file $RCX_RULES -lef_res

write_db DesignLib

write_verilog $PNR_DIR/outputs/${TOP}.v
write_verilog -include_pwr_gnd $PNR_DIR/outputs/${TOP}_pg.v
write_def $PNR_DIR/outputs/${TOP}.def
write_spef $PNR_DIR/outputs/${TOP}.spef
write_library $PNR_DIR/outputs/${TOP}.lib

 

