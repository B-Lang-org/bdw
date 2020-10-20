global BSPEC
global env


# Opens the specified project
handlers::open_project project.bspec 

# Opens the wizard 
create_import_bvi_wizard_window

set vdir [file join . Verilog ]
set files [lsort [glob  -directory $vdir *.v ]]


foreach f $files  {
#    $BSPEC(IMPORT_BVI) reset_wizard
    $BSPEC(IMPORT_BVI) action_switch vfr

    $BSPEC(IMPORT_BVI) read_verilog $f

#     # Go to Bluespec Module Definition step
#     $BSPEC(IMPORT_BVI) action_next
#     # Sets the interface name
#     $BSPEC(IMPORT_BVI) set_bluespec_interface_name "Ifc_test" 

#     # Go to Method Port Bindings step
#     $BSPEC(IMPORT_BVI) action_next

#     # Create method according to existence port
#     $BSPEC(IMPORT_BVI) auto_create_from_verilog

#     # Go to Path step
#     $BSPEC(IMPORT_BVI) action_next

#     # Go to Scheduling Annotation step
#     $BSPEC(IMPORT_BVI) action_next

#     # Go to Finish step
#     $BSPEC(IMPORT_BVI) action_next

#     # Sets the file name
#     $BSPEC(IMPORT_BVI) set_save_file_location "$f_test.bsv"

#     # Finish the wizard action
#     $BSPEC(IMPORT_BVI) save_now

}

# Closes the wizard
$BSPEC(IMPORT_BVI) action_close

exit

