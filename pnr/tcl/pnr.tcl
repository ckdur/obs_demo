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

#define_corners typ bc wc
#read_liberty -corner typ "$LIBMAIN"
#read_liberty -corner bc "$LIBBCMAIN"
#read_liberty -corner wc "$LIBWCMAIN"

# TODO: Didn't work to get all liberty like mems and IOs
#foreach LIB $LIBS {
#  read_liberty -corner typ "$LIB"
#}
#foreach LIB $LIBS_BC {
#  read_liberty -corner bc -min "$LIB"
#}
#foreach LIB $LIBS_WC {
#  read_liberty -corner wc -max "$LIB"
#}

# We assume the first LEF is the tech lef
set TECHLEF [lindex $LEFS 0]
set OTHERLEF [lrange $LEFS 1 end]

read_lef -tech $TECHLEF
#read_lef -library /usr1/iizuka/cadence/ROHM018/210107/RPDK20031_vdec_20201215/logic_library/ri18it183/lef/ri18it183.lef
#read_lef -library /usr1/iizuka/cadence/ROHM018/210107/RPDK20031_vdec_20201215/logic_library/ri18it183/lef/ri18it183_ant.lef
foreach LEFFILE $OTHERLEF {
  read_lef "$LEFFILE"
}

read_verilog $SYN_DIR/${TOP}_net.v
link_design ${TOP}

unset_propagated_clock [all_clocks]

####################################
## Cells declaration
####################################

set BUFCells [list it18_bufc_0 it18_bufc_1 it18_bufc_2 it18_bufc_3 it18_bufc_4 it18_bufc_5 it18_bufc_6 it18_bufc_7]
set INVCells [list it18_inv_0 it18_inv_1 it18_inv_2 it18_inv_3 it18_inv_4 it18_inv_5 it18_inv_6 it18_inv_7]
set FILLERCells [list it18_fillcap_1 it18_fillcap_2 it18_fillcap_3 it18_fillcap_4 it18_fillcap_5 it18_fillcap_6 it18_fillcap_7 it18_fillcap_8 it18_fillcap_9]
set DCAPCells [list it18_fillcap_1 it18_fillcap_2 it18_fillcap_3 it18_fillcap_4 it18_fillcap_5 it18_fillcap_6 it18_fillcap_7 it18_fillcap_8 it18_fillcap_9]
set DIODECells [list it18_antenna_0]

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
  initialize_floorplan -sites unit -aspect_ratio [expr $PX/$PY] -utilization [expr $PR*100] -core_space "$margin $margin $margin $margin"
}

add_global_connection -net VDD -inst_pattern .* -pin_pattern VDD -power
add_global_connection -net VSS -inst_pattern .* -pin_pattern VSS -power
set_voltage_domain -name CORE -power VDD -ground VSS

insert_tiecells "it18_to01_0/LO" -prefix "TIE_ZERO_"
insert_tiecells "it18_to01_0/HI" -prefix "TIE_ONE_"

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
make_tracks M1 -x_offset 0.24 -x_pitch 0.56 -y_offset 0.24 -y_pitch 0.56
make_tracks M2 -x_offset 0.28 -x_pitch 0.64 -y_offset 0.28 -y_pitch 0.64
make_tracks M3 -x_offset 0.28 -x_pitch 0.64 -y_offset 0.28 -y_pitch 0.64
make_tracks M4 -x_offset 0.28 -x_pitch 0.64 -y_offset 0.28 -y_pitch 0.64
make_tracks M5 -x_offset 0.46 -x_pitch 1.08 -y_offset 0.46 -y_pitch 1.08

####################################
## Power planning & SRAMs placement
####################################

define_pdn_grid \
    -name stdcell_grid \
    -starts_with POWER \
    -voltage_domain CORE \
    -pins "M4 M5"

add_pdn_stripe \
    -grid stdcell_grid \
    -layer M4 \
    -width 1.0 \
    -pitch $pitch \
    -offset $pitch \
    -spacing 0.46 \
    -starts_with POWER -extend_to_boundary

add_pdn_stripe \
    -grid stdcell_grid \
    -layer M5 \
    -width 1.0 \
    -pitch $pitch \
    -offset $pitch \
    -spacing 0.46 \
    -starts_with POWER -extend_to_boundary

add_pdn_connect \
    -grid stdcell_grid \
        -layers "M4 M5"

add_pdn_stripe \
        -grid stdcell_grid \
        -layer M1 \
        -width 0.48 \
        -followpins \
        -starts_with POWER

add_pdn_connect \
    -grid stdcell_grid \
        -layers "M1 M4"

add_pdn_ring \
        -grid stdcell_grid \
        -layers "M4 M5" \
        -widths "1.0 1.0" \
        -spacings "0.46 0.46" \
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
	-hor_layers M3 \
	-ver_layers M2

global_placement -density 1.0 -overflow 0.9 -init_density_penalty 0.0001 -initial_place_max_iter 20 -bin_grid_count 64

# TODO: Check resize.tcl, as it checks the size of the buffering

#set cell_pad_value [expr 3*$track]
# TODO: Most of the time, cell_pad_value is 4
set cell_pad_value 4
# TODO: Most of the time, diode_pad_value is 2
set diode_pad_value 2
set cell_pad_side [expr $cell_pad_value / 2]
set_placement_padding -global -right $cell_pad_side -left $cell_pad_side
set_placement_padding -masters $DIODECells -left $diode_pad_value
detailed_placement

#################################################
## Write out final files
#################################################
write_db DesignLib

if {![file exists outputs]} {
  file mkdir outputs
  puts "Creating directory outputs"
}
if {![file exists reports]} {
  file mkdir reports
  puts "Creating directory reports"
}

write_verilog ./outputs/${TOP}.v
write_verilog -include_pwr_gnd ./outputs/${TOP}_pg.v
write_def ./outputs/${TOP}.def

 

