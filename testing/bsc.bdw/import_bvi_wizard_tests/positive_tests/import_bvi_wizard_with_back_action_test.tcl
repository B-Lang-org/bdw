global BSPEC

# Opens the specified project
handlers::open_project project.bspec 

# Opens the wizard 
create_import_bvi_wizard_window

# Loads the verilog file
$BSPEC(IMPORT_BVI) read_from_file mult4/info_verilog_for_mkMult2

# Go to Bluespec Module Definition step
$BSPEC(IMPORT_BVI) action_next

# Sets the module name
$BSPEC(IMPORT_BVI) set_bluespec_module_name "module_test" 

# Sets the interface name
$BSPEC(IMPORT_BVI) set_bluespec_interface_name "Ifc_test" 

# Sets the default clock
$BSPEC(IMPORT_BVI) set_bluespec_input_clock_default "CLK"

# Sets the default reset
$BSPEC(IMPORT_BVI) set_bluespec_input_reset_default "RST"

# Go to Method Port Bindings step
$BSPEC(IMPORT_BVI) action_next

# Create method according to existence port
$BSPEC(IMPORT_BVI) auto_create_from_verilog

# Go to Path step
$BSPEC(IMPORT_BVI) action_next

# Go to Scheduling Annotation step
$BSPEC(IMPORT_BVI) action_next

# Go to Finish step
$BSPEC(IMPORT_BVI) action_next

# Sets the file name
$BSPEC(IMPORT_BVI) set_save_file_location "import_bvi_wizard_test.bsv"

$BSPEC(IMPORT_BVI) action_back
$BSPEC(IMPORT_BVI) action_back
$BSPEC(IMPORT_BVI) action_back
$BSPEC(IMPORT_BVI) action_back
$BSPEC(IMPORT_BVI) action_back

$BSPEC(IMPORT_BVI) action_next
$BSPEC(IMPORT_BVI) action_next
$BSPEC(IMPORT_BVI) action_next
$BSPEC(IMPORT_BVI) action_next
$BSPEC(IMPORT_BVI) action_next

# Finish the wizard action
$BSPEC(IMPORT_BVI) save_now

# Rename the wizard output file
exec cp import_bvi_wizard_test.bsv import_bvi1.bsv
exec mv import_bvi_wizard_test.bsv import_bvi_wizard_with_back_action_test.tcl.bdw-out

# Closes the wizard
$BSPEC(IMPORT_BVI) action_close

# Exits the workstation
exit

