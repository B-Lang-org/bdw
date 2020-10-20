
##
# @file import_bvi_wizard.tcl
#
# @brief Definition of the Import BVI Wizard window.
#

package require Bluetcl

##
# @brief Definition of class import_bvi_wizard 
# 
#catch "itcl::delete class import_bvi_wizard"
itcl::class import_bvi_wizard {
        inherit itk::Toplevel

        ##
        # @brief Changes the menu status for the Import BVI Wizard
        #
        # @param exp the expression, which should be parsed to integer
        #
        method get_port_value {exp}

        ##
        # @brief Returns the current screen
        #
        method get_current_screen {} {
                return $current_screen
        }

        ##
        # @brief Changes the menu status for the Import BVI Wizard
        #
        # @param m the name of menu from Import BVI Wizard
        # @param n the number of menu action from menu
        # @param st the status of menu action
        #
        method change_menu_status {m n st}

        ##
        # @brief Sets the Bluespec clock field of Input reset tab of Bluespec
        # Module Definition screen
        #
        method set_bluespec_input_reset {}

        ##
        # @brief Sets the Bluespec Inout tab of Bluespec Module Definition
        # screen
        #
        method set_bluespec_inout {}

        ##
        # @brief Refresh the wizard size
        #
        method refresh_wizard_size {}

        ##
        # @brief Closes the wizard
        #
        method action_close {}

        ##
        # @brief Opens a warning dialog and closes the wizard
        #
        method action_cancel {}

        ##
        # @brief Go to other screen
        #
        method action_next {}

        ##
        # @brief Go to previous screen
        #
        method action_back {}

        ##
        # @brief Switch to the given screen
        #
	# @param scr the name of the screen 
        #
        method action_switch {scr}

        ##
        # @brief Checks the conditions of the current step
        #
        method action_check {{type 0}}

        ##
        # @brief Shows the current generated bsv file
        #
        method action_show {}

        ##
        # @brief Enables Disables the menu item in the Wizard menu according to
        # the current step of the wizard
        #
        method open_wizard_menu {}

        ##
        # @brief Checks if the Parameters, Inputs or Outputs names are
        # duplicated
        #
	# @param name1 the list which contains the names of fields in the first
	# tab
	# @param name2 the list which contains the names of fields in the
	# second tab
        #
        method check_duplicate_name {name1 name2}

        ##
        # @brief Checks the conditions of verilog module overview screen.
        #
        method check_verilog_module_window {{type 0}}

        ##
        # @brief Checks the conditions of bluespec module definition screen.
        #
        method check_bluespec_module_window {{type 0}}

        ##
        # @brief Checks the validation of Bluespec module/interface names.
        #
        # @param name the name which will be checks valid or not
        #
        method check_valid_name {name}

        ##
        # @brief Checks the Bluespec input clock/reset tab.
        #
        # @param type the type of the tab (clock/reset)
        #
        method check_bluespec_input_clock_reset {type}

        ##
        # @brief Checks the Bluespec inout tab.
        #
        method check_bluespec_inout {}

        ##
        # @brief Creates the bsv file according to the current step of the
        # wizard into a temporary file
        #
        method build_output_string {}

        ##
        # @brief Checks the conditions of method port binding screen.
        #
        method check_method_port_window {{type 0}}

        ##
        # @brief Checks the conditions of combinational path screen.
        #
        method check_combinational_path_window {{type 0}}

        ##
        # @brief Checks the conditions of scheduling annotation screen.
        #
        method check_scheduling_annotation_window {{type 0}}

        ##
        # @brief Checks the conditions of finish screen.
        #
        method check_finish_window {{type 0}}

        ##
        # @brief Sets the finish window text frame numbering
        #
        method set_finish_numbering {}

        ##
        # @brief Openes Read Verilog dialog
        #
        # @param verilog boolean variable if the given file is verilog file or
        # not
        #
        method open_verilog {verilog}

        ##
        # @brief Openes "Save List To File" dialog
        #
        method save_list_to_file {}

        ##
        # @brief Adds a fields in Parameters tab of the Verilog Module Overview
        #
        # @param name the field name
        # @param parent the parent widget name
        # @param range the parameter range
        # 
        method add_verilog_parameter_field {name {parent ""} {range ""}}

        ##
        # @brief Adds a fields in Input tab of the Verilog Module Overview  
        #
        # @param name the field name
        # @param parent the parent widget name
        # @param type the type of the port
        # @param range the range of the port
        # 
        method add_verilog_input_field {name {parent ""} {type ""} {range ""}}

        ##
        # @brief Adds a fields in Output tab of the Verilog Module Overview  
        #
        # @param name the field name
        # @param parent the parent widget name
        # @param type the type of the port
        # @param range the range of the port
        # 
        method add_verilog_output_field {name {parent ""} {type ""} {range ""}}

        ##
        # @brief Adds a fields in Inout tab of the Verilog Module Overview  
        #
        # @param name the field name
        # @param parent the parent widget name
        # @param range the range of the port
        # 
        method add_verilog_inout_field {name {parent ""} {range ""}}

        ##
        # @brief Adds a fields in Bluespec Module Definition
        #
        # @param name the field name
        # @param parent the parent widget name
        # 
        method add_bluespec_package_import_field {name {parent ""}}

        ##
        # @brief Sets the list of Bluespec package import fields
        #
        # @param name the field name
        # 
        method set_bluespec_package_import_list {name}

        ##
        # @brief Adds a fields in Bluespec Module Definition
        #
        # @param name the field name
        # @param parent the parent widget name
        # 
        method add_bluespec_provisos_field {name {parent ""}}

        ##
        # @brief Adds a fields in Bluespec Module Definition
        #
        # @param name the field name
        # @param parent the parent widget name
        # 
        method add_bluespec_module_args_field {name {parent ""}}

        ##
        # @brief Adds a fields in Input clock tab of Bluespec Module Definition
        #
        # @param name the field name
        # 
        method add_bluespec_parameter_binding {name}

        ##
        # @brief Adds a fields in Input clock tab of Bluespec Module Definition
        #
        # @param name the field name
        # @param parent the parent widget name
        # 
        method add_bluespec_input_clock_field {name {parent ""}}

        ##
        # @brief Deselects all currently selected checkbuttons and selects the
        # checkbutton
        #
        method select_default_clock {}

        ##
        # @brief Adds a fields in Input reset tab of Bluespec Module Definition
        #
        # @param name the field name
        # @param parent the parent widget name
        # 
        method add_bluespec_input_reset_field {name {parent ""}}

        ##
        # @brief Adds a fields in Inout tab of Bluespec Module Definition
        #
        # @param name the field name
        # @param parent the parent widget name
        # 
        method add_bluespec_inout_field {name {parent ""}}

        ##
        # @brief Deselects all currently selected checkbuttons and selects the
        # checkbutton
        #
        method select_default_reset {}

        ##
        # @brief Creates the Method bindings frame
        #
        # @param f the frame for the field
        # @param name the name of the method
        # @param type the type of the method
        # @param parent the parent widget name
        # @param arg the argument type
        #
        method create_method_bindings_frame {f {name ""} {type ""} \
                {parent ""} {arg ""}} 

        ##
        # @brief Selects all chechbuttons and displays port/method/subinterface
        # bindings in the Method Port Bindings screen
        #
        method select_all_bindings {}

        ##
        # @brief Hide the unused port pane
        #
        method hide_unused_ports {}

        ##
        # @brief Show the port/method/subinterface field
        #
        method show_hierarchy_ports {}

        ##
        # @brief Show the info field
        #
        method show_info_field {}

        ##
        # @brief Deselects all chechbuttons and displays
        # port/method/subinterface bindings in the Method Port Bindings screen
        #
        method deselect_all_bindings {}

        ##
        # @brief Hide the Port/Method/Subinterface field
        #
        method hide_bindings {}

        ##
        # @brief Removes the port/method/subinterface bindings which are
        # selected
        #
        method remove_bindings {}

        ##
        # @brief Removes the port/method/subinterface child bindings which are
        # selected
        #
        method remove_given_binding {but}

        ##
        # @brief Creates the Method port bindings frame
        #
        # @param f the frame for the field
        # @param name the name of the port
        #
        method create_port_bindings_frame {f {name ""}}

        ##
        # @brief Creates the Method port bindings frame
        #
        # @param f the frame for the field
        # @param name the name of the interface
        # @param parent the parent widget name
        #
        method create_interface_bindings_frame {f {name ""} {parent ""}}

        ##
        # @brief Adds a Method bindings fields in Method port binding
        #
        # @param f the frame for the field
        # @param name the field name
        # @param text the BSV type name
        # @param parent the parent widget name
        # 
        method add_method_binding_args_field {f name {parent ""} {text ""}}

        ##
        # @brief Adds a Port bindings fields in Method port binding
        #
        # @param f the frame for the field
        # @param name the field name
        # @param parent the parent widget name
        # @param ind the port index
        # 
        method add_port_binding_field {f name {parent ""} ind}

        ##
        # @brief Adds a Combinational path field
        #
        # @param f the frame for the field
        # @param name the field name
        # @param parent the parent widget name
        # 
        method add_combinational_path_field {f name {parent ""}}

        ##
        # @brief Adds a Combinational path Input field
        #
        # @param f the frame for the field
        # @param name the field name
        # @param parent the parent widget name
        # 
        method add_combinational_path_input_field {f name {parent ""}}

        ##
        # @brief Adds a Combinational path Output field
        #
        # @param f the frame for the field
        # @param name the field name
        # @param parent the parent widget name
        # 
        method add_combinational_path_output_field {f name {parent ""}}

        ##
        # @brief Returns the verilog module name
        #
        method get_verilog_module_name {}

        ##
        # @brief Returns the content of the verilog parameter tab of the
        # verilog module overview screen
        #
        method get_verilog_parameter {}

        ##
        # @brief Returns the content of the verilog input tab of the
        # verilog module overview screen
        #
        method get_verilog_input {}

        ##
        # @brief Returns the content of the verilog output tab of the
        # verilog module overview screen
        #
        method get_verilog_output {}

        ##
        # @brief Returns the content of the verilog inout tab of the
        # verilog module overview screen
        #
        method get_verilog_inout {}

        ##
        # @brief Sets the Bluespec module name
        #
        # @param name the module name
        #
        method set_bluespec_module_name {name}

        ##
        # @brief Sets the Bluespec interface name
        #
        # @param name the interface name
        #
        method set_bluespec_interface_name {name}

        ##
        # @brief Sets the Bluespec input clock default
        #
        # @param name the default clock name
        #
        method set_bluespec_input_clock_default {name}

        ##
        # @brief Sets the Bluespec input reset default
        #
        # @param name the default reset name
        #
        method set_bluespec_input_reset_default {name}

        ##
        # @brief Sets the Bluespec interface type
        #
        # @param type the type of interface (Define From Method/ Use Existing)
        # @param screen the current screen name
        #
        method set_interface_type {type screen}

        ##
        # @brief Sets the Bluespec Sub interface type
        #
        # @param type the type of interface (Define From Method/ Use Existing)
        # @param id the subinterface id
        #
        method set_subinterface_type {type id}
        method set_parameter_expression {parameter expression}
        ##
        # @brief Returns the contents of the items in the bluespec module
        # definition screen
        #
        method get_bluespec_module_name {}
        method get_bluespec_interface_type {}
        method get_bluespec_interface_name {}
        method get_bluespec_package_import {}
        method get_bluespec_provisos {}
        method get_bluespec_module_args {}
        method get_bluespec_parameter_binding {}
        method get_bluespec_input_clock {}
        method get_bluespec_input_clock_default {}
        method get_bluespec_input_reset {}
        method get_bluespec_input_reset_default {}
        method get_bluespec_inout {}

        ##
        # @brief Returns the contents of the items in the method port
        # bindings screen
        #
        method get_method_binding {}
        method get_port_binding {}
        method get_interface_binding {}
        method get_interface_name {}

        ##
        # @brief Returns the list with input and corresponding output port
        # names which are specified at the combinational path step of the wizard
        #
        method get_combinational_path_input_output {}

        ##
        # @brief Returns the scheduling annotation pear list which should be
        # displayed
        #
        # @param action the corresponding action (e.g. next +/ previous -)
        # @param type the boolean variable which on or off the next/prev
        # functionality
        #
        method get_scheduling_annotation_current_page {action {type 1}}

        ##
        # @brief Returns the list with 2 method names and corresponding
        # annotation which is specified at the scheduling annotation step of
        # the wizard
        #
        method get_scheduling_annotation {}

	##
	# @brief Sets the file location to save the wizard info
	#
	# @param name the file name
	#
        method set_save_file_location {name}

	##
	# @brief Returns the file location to save the wizard info
	#
        method get_save_file_location {}

        ##
        # @brief Clear the commbobox entry
        #
        # @param cmb the combobox frame name
        #
        method empty_combobox {cmb}

        ##
        # @brief Removes the subinterfaces from the list which have no
        # subinterface
        #
        method configure_interface_list {}

        ##
        # @brief Deletes the given frame and removes it's name from the list
        #
        # @param variable the list name
        # @param name the component name which will deleted
        #
        method delete_field {variable name {type ""}}

        ##
        # @brief Reads the verilog file
        #
        # @param file the file name
        #
        method read_verilog {file}

        ##
        # @brief Reads the verilog informtion from the file
        #
        # @param file the file name
        #
        method read_from_file {file}

        ##
        # @brief Finds the parameters, inputs, outputs from the string
        #
        # @param string the given string
        #
        method find_param_input_output {string}

        ##
        # @brief Removes the parameter, input, output fields from the Verilog
        # module overview tab
        #
        # @param string the given string
        #
        method remove_param_input_output {}

        ##
        # @brief Adds the parameter, input, output fields the Verilog
        # module overview tab
        #
        # @param vname the list of module names read from verilog file
        # @param vinp verilog inputs 
        # @param vout verilog outputs
        # @param vparam verilog parameters
        # @param vinout verilog inouts
        #
        method fill_param_input_output {vname vinp vout vparam vinout}

        ##
        # @brief Displays or hides the port/method/subinterface binding
        # sections  
        #
        # @param bt the checkbutton button name which is selected 
        # @param pa port/method/subinterface binding frame
        # @param list the list of widgets. 
        # @param f the frame name. 
        #
        method show_method_port_ifc {bt pa list {f ""}}

        ##
        # @brief Enables/disables the appropriate fields of the Method Bindings
        # section.
        #
        # @param name the method name 
        # @param id the id for method name 
        #
        method method_binding_enable {name id}

        ##
        # @brief Updates the Port/Method/Subinterface bindings list
        #
        # @param id the id of unnamed method/interface
        # @param type the type can method or interface
        #
        method update_method_ifc_list_name {id type}

        ##
        # @brief Opens Build Skeleton dialog to load an interface with its
        # contents (method/interface)
        #
        # @param frame the frame for method or interface
        # @param parent the parent for method or interface
        #
        method build_skeleton {frame {parent ""} {cis ""}}

        ##
        # @brief Opens Build Skeleton dialog to load an interface with its
        # contents (method/interface)
        #
        # @param id the id of sub interface
        #
        method set_interface {{id ""}}

        ##
        # @brief Sets the combobox bindings
        #
        # @param cmb the combobox frame name
        #
        method set_cmb_bindings {cmb}

        ##
        # @brief Sets the Scheduling new annotation
        #
        # @param n1 the first method name
        # @param n2 the second method name
        # @param id the annotation frame id
        #
        method set_new_annotation {n1 n2 id}

        ##
        # @brief Save the import BVI file
        #
        # @param s A boolean variable to give a status dialog or nor
        #
        method save_now {{s "false"}}

        ##
        # @brief Creates methods according to verilog input/output ports. 
        #
        method auto_create_from_verilog {}

        ##
        # @brief Opens a dialog to choose a file 
        #
        method select_file {}

        ##
        # @brief Compile bvi file 
        #
        method compile_file {}

        ##
        # @brief Gets the compile button name 
        #
        method get_compile_id {}

        ##
        # @brief Creates the right side of Scheduling annotation screen
        #
        # @param action the corresponding action (e.g. next +/ previous -)
        # @param type the boolean variable which on or off the next/prev
        # functionality
        #
        method create_scheduling_annotation_window_right {action {type 1}}

        method get_method_list {} { return $methodlist }

        public common TotalPairs 0
        public common FilteredPairs 0
        public common TotalPages 0
        private {

                ##
                # @brief The Import BVI Wizard window name
                #
                variable win "" 

                ##
                # @brief The Import BVI Wizard window Method Port Binding
                # screen width
                #
                variable current_width ""

                ##
                # @brief The current screen name
                #
                variable screens ""

                ##
                # @brief A list which contains the screen names which are
                # passed
                #
                variable current_screen ""

                # Variables which contain the names of existing fields

                ## ***** Verilog Module Overview screen *****

                ##
                # @brief A list which contains the frame names of Parameter
                # fields 
                #
                variable verilog_parameter ""

                ##
                # @brief A list which contains the frame names of Input fields 
                #
                variable verilog_input ""

                ##
                # @brief A list which contains the frame names of Output fields 
                #
                variable verilog_output ""

                ##
                # @brief A list which contains the frame names of Inout fields 
                #
                variable verilog_inout ""

                ## ***** Bluespec Module definition screen *****

                ##
                # @brief A list which contains the frame names of Package
                # Import fields 
                #
                variable bluespec_package_import ""

                ##
                # @brief A list which contains the frame names of Provisos
                # fields 
                #
                variable bluespec_provisos ""

                ##
                # @brief A list which contains the frame names of Bluespec
                # module arguments fields 
                #
                variable bluespec_module_args ""

                ##
                # @brief A list which contains the frame names in Parameter
                # Binding tab
                #
                variable bluespec_parameter_binding ""

                ##
                # @brief A list which contains the frame names in Input clock
                # tab
                #
                variable bluespec_input_clock ""

                ##
                # @brief A list which contains the frame names in Input reset
                # tab
                #
                variable bluespec_input_reset ""
                
                ##
                # @brief A list which contains the frame names in Inout tab
                #
                variable bluespec_inout ""
                
                ##
                # @brief A list which contains the frame names in Parameter
                # Binding tab. Is set to check for a new added field.
                #
                variable bluespec_parameter_binding_temp ""

                ##
                # @brief A list which contains the frame names in Method Ports
                # Bindings screen.
                #
                variable propagate_list ""

                ## ***** Method Port Binding screen *****

                ##
                # @brief A list which contains the frame names of Method
                # Bindings section
                #
                variable method_bindings ""

                ##
                # @brief An array which contains the frame names of Arguments
                # fields (in Method binding section) according to method frame
                # name.
                #
                variable METHOD_BINDING_ARGS

                ##
                # @brief A list which contains the frame names of Subinterface
                # Bindings section
                #
                variable interface_binding ""

                ##
                # @brief A list which contains the frame names of the fields in
                # Port Binding section
                #
                variable port_binding ""

                ##
                # @brief A list which contains the frame names of Port Binding
                # section
                #
                variable method_port_bindings ""

                ## ***** Combinational Path screen *****

                ##
                # @brief A list which contains the frame names of Combinational
                # Path section
                #
                variable combinational_path ""

                ##
                # @brief A list which contains the frame names of Input fields
                # in Combinational Path section
                #
                variable combinational_path_input ""

                ##
                # @brief A list which contains the frame names of Output fields
                # in Combinational Path section
                #
                variable combinational_path_output ""

                ##
                # @brief A unique id for Scheduling Annotation field
                #
                variable schedule_cnt 1

                ##
                # @brief A list which contains the frame names of Scheduling
                # Annotation section
                #
                variable scheduling_annotation ""

                ##
                # @brief A list which contains the names of all method pairs
                #
                variable methodpairs [list]
                variable methodlist  [list]

                ##
                # @brief An array which contains the annotations according to
                # the name of the method pair
                # public and common to allow shared access by low-level widgets
                #
                variable sched_annotation_list [list C CF SB SBR SA SAR]
                public common SCHED_ANNOTATION
                variable SCHED_ANNOTATION_TMP

                ##
                # @brief Starts the wizard process. 
                #
                method start_process {}

                ##
                # @brief Finish the wizard process. 
                #
                method finish_process {}

                ##
                # @brief Check verilog module name specification
                #
                method is_verilog_module_name_empty {} 

                ##
                # @brief Check verilog port existence
                #
                # @param list the ports list
                #
                method is_verilog_port_specify {list} 

                ##
                # @brief Check if the verilog port is duplicated
                #
                # @param ti1 the port index
                # @param list the ports list
                # @param sl the tab index 
                #
                method is_verilog_port_name_duplicated {ti1 list sl}

                ##
                # @brief Check if the verilog ports is specified
                #
                # @param i the port list 
                # @param t1 the tab name 
                # @param sl the tab index 
                # @param l1 the list index
                #
                method is_verilog_ports_specified {i t1 sl l1} 

                ##
                # @brief Check if the verilog port value is specified
                #
                # @param i the port list 
                # @param t1 the tab name 
                # @param sl the tab index 
                # @param l1 the list index
                #
                method is_verilog_port_value_specified {i t1 sl l1} 

                ##
                # @brief Check if the verilog port range correct
                #
                # @param p the port value 
                # @param l1 the list index
                # @param sl the tab index 
                # @param i the port list 
                #
                method is_verilog_port_range_correct {p l1 sl i} 

                ##
                # @brief Check if the verilog port range correct
                #
                # @param h the hight limit of the range 
                # @param l the low limit of the range 
                # @param i the port list 
                # @param l1 the list index
                # @param sl the tab index 
                # @param t1 the tab name 
                #
                method is_verilog_port_set_correct {h l i l1 sl t1} 

                ##
                # @brief Check if the bluespec module name correct
                #
                method is_bluespec_module_name_correct {} 

                ##
                # @brief Check if the bluespec interface type correct
                #
                method is_bluespec_interface_type_correct {} 

                ##
                # @brief Check if the bluespec package import correct
                #
                method is_bluespec_package_import_correct {} 

                ##
                # @brief Check if the bluespec provisos correct
                #
                method is_bluespec_provisos_correct {} 

                ##
                # @brief Check if the bluespec module arguments correct
                #
                method is_bluespec_module_args_correct {} 

                ##
                # @brief Check if the bluespec parameter correct
                #
                method is_bluespec_parameter_correct {} 

                ##
                # @brief Check if the bluespec clocks, resets ports specified
                #
                # @param i the bluespec clock/reset information
                # @param title the tab name
                # @param list the clock/reset frames list
                # @param ti the clock/reset tab index
                #
                method is_bluespec_input_clock_reset_port_empty {i type list ti}

                ##
                # @brief Check if the bluespec clocks, resets name duplicated
                #
                # @param i the bluespec clock/reset information
                # @param title the tab name
                # @param list the clock/reset frames list
                # @param ti the clock/reset tab index
                #
                method is_bluespec_input_clock_reset_duplicated {i type list ti}

                ##
                # @brief Check if the bluespec clocks, resets ports begin with
                # lower case
                #
                # @param i the bluespec clock/reset information
                # @param title the tab name
                # @param list the clock/reset frames list
                # @param ti the clock/reset tab index
                #
                method is_bluespec_input_clock_reset_port_lower {i type list ti}

                ##
                # @brief Check if the bluespec clocks Verilog port
                # specified
                #
                # @param i the bluespec clock/reset information
                # @param title the tab name
                # @param list the clock/reset frames list
                # @param ti the clock/reset tab index
                #
                method is_bluespec_input_clock_verilog_port_specified {i \
                                                                type list ti}

                ##
                # @brief Check if the bluespec resets Bluespec clock specified
                #
                # @param i the bluespec clock/reset information
                # @param title the tab name
                # @param list the clock/reset frames list
                # @param ti the clock/reset tab index
                #
                method is_bluespec_input_reset_bclock_specified {i type list ti}

                ##
                # @brief Check if the bluespec clocks, resets expression 
                # specified
                #
                # @param i the bluespec clock/reset information
                # @param title the tab name
                # @param list the clock/reset frames list
                # @param ti the clock/reset tab index
                #
                method is_bluespec_input_clock_reset_expr_specified {i \
                                                                type list ti}

                ##
                # @brief Check if the bluespec clocks, resets expression
                # specified correct
                #
                # @param i the bluespec clock/reset information
                # @param title the tab name
                # @param list the clock/reset frames list
                # @param ti the clock/reset tab index
                #
                method is_bluespec_input_clock_reset_expr_lower {i type list ti}

                ##
                # @brief Check if the bluespec clocks, resets and inouts
                # correct
                #
                method is_bluespec_clock_reset_inout_correct {} 

                ##
                # @brief Check if the Verilog port of Inout tab of Bluespec
                # Module Definition screen correct
                #
                # @param i the verilog port
                #
                method is_bluespec_inout_verilog_port_correct {i} 

                ##
                # @brief Check if the Bluespec clock of Inout tab of Bluespec
                # Module Definition screen correct
                #
                # @param i the bluespec ckock
                #
                method is_bluespec_inout_bluespec_clock_correct {i} 

                ##
                # @brief Check if the Bluespec reset of Inout tab of Bluespec
                # Module Definition screen correct
                #
                # @param i the bluespec reset
                #
                method is_bluespec_inout_bluespec_reset_correct {i} 

                ##
                # @brief Check if the Expression of Inout tab of Bluespec
                # Module Definition screen specified
                #
                # @param i the inout expression
                #
                method is_bluespec_inout_expression_specified {i} 

                ##
                # @brief Check if the Expression of Inout tab of Bluespec
                # Module Definition screen valid
                #
                # @param i the inout expression
                #
                method is_bluespec_inout_expression_valid {i} 

                ##
                # @brief Check if the method port interface type correct
                #
                method is_method_port_interface_type_correct {} 

                ##
                # @brief Check if the method port sub interfaces type correct
                #
                method is_method_port_subinterface_type_correct {} 

                ##
                # @brief Check if the method port sub interfaces specified 
                #
		# @param i the sub interface list
                #
                method is_method_port_subinterface_specify {i}

                ##
                # @brief Check if the method port sub interfaces type correct 
                #
		# @param i the sub interface list
                #
                method is_method_port_subinterface_correct {i}

                ##
                # @brief Check if the method port sub interfaces type specified 
                #
		# @param i the sub interface list
                #
                method is_method_port_subinterface_type_specify {i}

                ##
                # @brief Check if the method port sub interfaces type duplicated
                #
		# @param i the sub interface list
		# @param ifc the sub interface all list
                #
                method is_method_port_subinterface_duplicated {i ifc}

                ##
                # @brief Check if the method port methods correct
                #
                method is_method_port_methods_correct {}

                ##
                # @brief Check if the method name specified
                #
		# @param mn the method name
                #
                method is_method_name_specify {mn}

                ##
                # @brief Check if the method name correct 
                #
		# @param mn the method name
                #
                method is_method_name_correct {mn}

                ##
                # @brief Check if the method type specified 
                #
		# @param i the method list
		# @param mn the method name
                #
                method is_method_type_specify {i mn}

                ##
                # @brief Check if the method Return signal specified correct
                #
		# @param i the method list
                #
                method is_method_return_signal_correct {i}

                ##
                # @brief Check if the method arguments correct 
                #
		# @param args the arguments list
		# @param mn the method name
                #
                method is_method_args_correct {args mn}

                ##
                # @brief Check if the method arguments BSV type specified 
                #
		# @param a the argument list
		# @param mn the method name
                #
                method is_method_args_bsv_type_specify {a mn}

                ##
                # @brief Check if the method arguments name specified 
                #
		# @param a the argument list
		# @param mn the method name
                #
                method is_method_args_name_specify {a mn}

                ##
                # @brief Check if the method enable specified 
                #
		# @param i the method list
		# @param en the method enable name
		# @param mn the method name
		# @param vinp the verilog input list
		# @param id the current method id
                #
                method is_method_enable_specify {i en mn vinp id}

                ##
                # @brief Check if the method argument verilog name specify
                # correct 
                #
		# @param args the method arguments list
		# @param vinp the verilog input list
		# @param mn the method name
                #
                method is_method_args_name_correct {args vinp mn}

                ##
                # @brief Check if the methods name duplicated
                #
		# @param fr the method frame name
		# @param mlist the mothods list
		# @param mn the method name
                #
                method is_method_name_duplicated {fr mlist mn}

                ##
                # @brief Check if the methods ports duplicated
                #
		# @param args the method arguments list
		# @param mlist the mothods list
		# @param mn the method name
                #
                method is_method_ports_duplicated {args mlist mn}

                ##
                # @brief Check if the methods argument ports and enables
                # duplicated or not
                #
		# @param vn the method argument verilog name
		# @param mlist the mothods list
		# @param mn the method name
                #
                method is_methods_args_enables_same {vn mlist mn}

                ##
                # @brief Check if the methods arguments ports duplicated or not
                #
		# @param vn the method argument verilog name
		# @param mlist the mothods list
		# @param mn the method name
                #
                method is_methods_args_duplicated {vn mlist mn}

                ##
                # @brief Check if the methods arguments and port bindings ports
                # duplicated or not
                #
		# @param vn the method argument verilog name
		# @param mn the method name
                #
                method is_methods_args_ports_bindings_same {vn mn}

                ##
                # @brief Check if the port bindings correct 
                #
                method is_port_binding_correct {}

                ##
                # @brief Check if the port bindings verilog name specified
                #
		# @param i the port binding list
                #
                method is_port_binding_verilog_name_specify {i}

                ##
                # @brief Check if the port bindings verilog name specified
                # correct
                #
		# @param i the port binding list
		# @param vinp the verilog input port list
                #
                method is_port_binding_verilog_name_correct {i vinp}

                ##
                # @brief Check if the port bindings bsv expression specified
                #
		# @param i the port binding list
                #
                method is_port_binding_bsv_expression_specify {i}

                ##
                # @brief Check if the combinational paths inputs and outputs
                # specified
                #
		# @param list the combinational paths input output list
                #
                method is_combinational_path_input_output_specify {list}

                ##
                # @brief Check if the combinational paths inputs and outputs
                # duplicated
                #
		# @param list the combinational paths input output list
                #
                method is_combinational_path_input_output_duplicated {list}

                ##
                # @brief Check if the scheduling annotations specified
                #
                method is_scheduling_annotation_specify {}

                ##
                # @brief Creates the menubar
                #
                method create_menubar {} 

                ##
                # @brief Creates the Wizard menu
                #
                method create_wizard_menu {} 

                ##
                # @brief Creates the Help menu
                #
                method create_help_menu {} 

                ##
                # @brief Creates Back, Check and Next
                #
                method create_action_buttons {} 
              
                ##
                # @brief Creates screen for Verilog module overview
                #
		# @param action the action (back/next) which calls this method
		#
                method create_verilog_module_window {{action ""}} 
              
                ##
                # @brief Creates the buttons needed for Verilog module
                #
                method create_verilog_buttons {} 

                ##
                # @brief Creates the widgets for Verilog module overview
                #
                method create_verilog_overview {} 

                ##
                # @brief Creates the tabnotebook widget in the Verilog module
                # overview screen
                #
                method create_verilog_overview_tabnotebook {} 

                ##
                # @brief Creates the Parameters tab in the Verilog module
                # overview screen
                #
                method create_verilog_overview_parameter_tab {} 

                ##
                # @brief Creates the Input tab in the Verilog module
                # overview screen
                #
                method create_verilog_overview_input_tab {} 

                ##
                # @brief Creates the Output tab in the Verilog module
                # overview screen
                #
                method create_verilog_overview_output_tab {} 

                ##
                # @brief Creates the Inout tab in the Verilog module
                # overview screen
                #
                method create_verilog_overview_inout_tab {} 

                ##
                # @brief Creates screen for Bluespec module definition
                #
		# @param action the action (back/next) which calls this method
		#
                method create_bluespec_module_window {{action ""}} 

                ##
                # @brief Sets the Bluespec module definition screen settings
                #
                method set_bluespec_module_window {} 

                ##
                # @brief Sets the values in the tabs of Bluespec module
                # definition screen.
                #
                method set_bluespec_module_values {} 

                ##
                # @brief Creates the tabnotebook widget in the Bluespec module
                # screen
                #
                method create_bluespec_module_tabnotebook {}

                ##
                # @brief Creates the Parameter Bindings tab in the Bluespec
                # module screen
                #
                method create_bluespec_module_parameter_binding_tab {}

                ##
                # @brief Creates the Input Clocks tab in the Bluespec
                # module screen
                #
                method create_bluespec_module_input_clock_tab {}

                ##
                # @brief Creates the Input Resets tab in the Bluespec
                # module screen
                #
                method create_bluespec_module_input_reset_tab {}

                ##
                # @brief Creates the Inout tab in the Bluespec module screen
                #
                method create_bluespec_module_inout_tab {}

                ##
                # @brief Creates the left side of the Bluespec module
                # definition screen
                #
                method create_bluespec_module_left {} 
              
                ##
                # @brief Creates the right side of the Bluespec module
                # definition screen
                #
                method create_bluespec_module_right {} 

                ##
                # @brief Creates screen for Method port bindings
                #
		# @param action the action (back/next) which calls this method
		#
                method create_method_port_window {{action ""}} 

                ##
                # @brief Sets the Method, Port Interface add remove size
                #
		# @param parent the frame parent name
		# @param type the frame type (method, port, interface)
		# @param action the action (+/-) add or remove
		# @param frame the frame name
                #
                method set_method_port_interface_size {parent type action frame}

                ##
                # @brief Sets the Method port bindings window setings
                #
                method set_method_port_window {} 

                ##
                # @brief Creates the Method port bindings screen
                #
                method create_method_port {} 

                ##
                # @brief Creates the screen for Combinational path
                #
		# @param action the action (back/next) which calls this method
		#
                method create_combinational_path_window {{action ""}} 

                ##
                # @brief Sets the Combinational path screen settings
                #
                method set_combinational_path_window {} 

                ##
                # @brief Creates the path part of Combinational path window
                #
                method create_combinational_path {} 

                ##
                # @brief Creates the screen for Scheduling annotation
                #
		# @param action the action (back/next) which calls this method
		#
                method create_scheduling_annotation_window {{action ""}}

                ##
                # @brief Creates the left side of Scheduling annotation screen
                #
                method create_scheduling_annotation_window_left {}

                ##
                # @brief Sets the Scheduling annotation screen settings
                #
                method set_scheduling_annotation_window {}

                ##
                # @brief Sets the scheduling annotations for all the methods
                #
                method generate_scheduling_annotations {} 

                ##
                # @brief Sets the Scheduling annotations for the given methods 
                #
		# @param m1 the first method name 
                # @param m2 the second method name @param list a list which
                # contains lists with informations of the method
		# @param id1 the unique id of the first method
		# @param id2 the unique id of the second method
                #
                method add_scheduling_annotations {m1 m2 list id1 id2}

                ##
                # @brief Creates the screen for Finish step
                #
		# @param action the action (back/next) which calls this method
		#
                method create_finish_window {{action ""}}

                ##
                # @brief Creates the Finish step top
                #
                method create_finish_window_top {}

                ##
                # @brief Creates the Finish step bottom
                #
                method create_finish_window_bottom {}

                ##
                # @brief Set the Finish step settings
                #
                method set_finish_window {}

                ##
                # @brief Hides all screens and displays the specified screen
                #
                # @param frame the frame to be displayed
		# @param action the action (back/next) which calls this method
                #
                # @return 1 if the frame is already created and 0 otherwise
                #
                method hide_screens {{frame ""} {action ""}} 

                ##
                # @brief Adds components to statusbar
                #
                # @param f the frame for the statusbar 
                # @param cname name of the component
                # @param cval the value of the component
                # @param side the side to display the component
                #
                method add_status_component {f cname cval side}

                ##
                # @brief Adds a frame  
                #
                # @param f the frame for the frame
                # @param name the frame name
                # @param x the frame horizontal distance from other widgets
                # @param y the frame vertical distance from other widgets
                # @param side the frame placement
                # @param exp boolean variable to expand the widget the or not
                #
                method add_frame {f name {x 0} {y 0} {side "top"} {exp "true"}}

                ##
                # @brief Adds a labeled frame
                #
                # @param f the frame for the frame
                # @param name the frame name
                # @param label the label for the frame
                # @param x the frame horizontal distance from other widgets
                # @param y the frame vertical distance from other widgets
                # @param side the frame placement
                # @param exp boolean variable to expand the widget the or not
                # @param pos the label position
                # @param relief the label relief
                #
                method add_labeledframe {f name label {x 0} {y 0} \
                        {side "top"} {exp "true"} {pos "nw"} {relief "flat"}}

                ##
                # @brief Adds a label
                #
                # @param f the frame for the label
                # @param name the label name
                # @param label the text of the label
                # @param x the label horizontal distance from other widgets
                # @param y the label vertical distance from other widgets
                # @param side the label placement
                # @param exp boolean variable to expand the widget the or not
                #
                method add_label {f name label {x 0} {y 0} \
                        {side "top"} {exp "true"}}

                ##
                # @brief Adds a scrolledframe  
                #
                # @param f the frame for the frame
                # @param name the frame name
                # @param label the label for the scrolledframe
                # @param side the frame placement
                # @param x the frame horizontal distance from other widgets
                # @param y the frame vertical distance from other widgets
                # @param exp boolean variable to expand the widget the or not
                # @param hscroll the value for hscrollmode can be static,
                # dynamic or none
                # @param vscroll the value for vscrollmode can be static,
                # dynamic or none
                #
                method add_scrolledframe {f name label {side "top"} \
                        {x 0} {y 0} {exp "true"} \
                        {hscroll "dynamic"} {vscroll "dynamic"} {fill "both"}} 

                ##
                # @brief Adds a scrolledtext
                #
                # @param f the frame for the frame
                # @param name the frame name
                # @param label the label for the scrolledtext
                # @param hmode the horizontal scroll mode
                # @param vmode the vertical scroll mode
                # @param exp boolean variable to expand the widget or not
                #
                method add_scrolledtext {f name label {hmode "static"} \
                                                {vmode "static"} {exp "true"}}

                ##
                # @brief Adds an entryfield   
                #
                # @param f the frame for entry
                # @param name the entry name
                # @param label the label for the entry
                # @param y the entry vertical distance from other widgets
                # @param x the entry horizontal distance from other widgets
                # @param side the entryfield placement
                # @param exp boolean variable to expand the widget or not
                # @param fg the colour for the text of the entry
                # @param cmd the command to be executed under Return button
                # @param lp the position of the label text 
                #
                method add_entryfield {f name label {y 0} {x 0} {side "top"} \
                                {exp "false"} {fg "#696969"} {cmd ""} {lp "w"}}

                ##
                # @brief Adds an text entry
                #
                # @param f the frame for text
                # @param name the text name
                # @param label the label for the text
                # @param y the text vertical distance from other widgets
                # @param height the height of the text widget
                # @param side the text placement
                #
                method add_textentry {f name label {y 0} {height 0.5} \
                                                        {side "top"}}

                ##
                # @brief Adds an combobox
                #
                # @param f the frame for combobox
                # @param name the combobox name
                # @param label the label for the combobox
                # @param y the combobox vertical distance from other widgets
                # @param x the combobox horizontal distance from other widgets
                # @param side the combobox placement
                # @param cmd the combobox selection command
                # @param fg the colour for the text of the combobox
                # @param lp the position of the label text 
                #
                method add_combobox {f name label {y 0} {x 0} {side "top"} \
                                        {cmd ""} {fg "#696969"} {lp "w"}}

                ##
                # @brief Adds a push button 
                # 
                # @param f the frame for button
                # @param name the button name
                # @param text the button text
                # @param cmd the button push command
                # @param width the button width
                # @param y the button vertical distance from other widgets
                # @param side the button placement
                # @param state the button state
                # @param height the button height
                # @param image to be displayed on the button 
                #
                method add_button {f name text cmd width {y 0} {side "top"} \
                                       {state "normal"} {image ""} {expand {false}}}

                ##
                # @brief Adds an scrolledlistbox   
                #
                # @param f the frame for scrolledlistbox
                # @param name the scrolledlistbox name
                # @param label the label for the scrolledlistbox
                # @param cmd the scrolledlistbox selection command
                # @param width the scrolledlistbox width
                # @param height the scrolledlistbox height
                # @param side the scrolledlistbox placement
                #
                method add_scrolledlistbox {f name label {cmd ""} {width 150} \
                                                {height 100} {side "top"}}

                ##
                # @brief Adds a checkbutton  
                #
                # @param f the frame for checkbutton 
                # @param name the checkbutton name
                # @param text the label for the checkbutton
                # @param cmd the checkbutton selection command
                # @param side the checkbutton placement
                # @param x the checkbutton horizontal distance from other
                # widgets
                # 
                method add_checkbutton {f name text cmd {side "top"} {x 4}}

                ##
                # @brief Adds a checkbox 
                #
                # @param f the frame for checkbox
                # @param name the checkbox name
                # @param label the label for the checkbox
                # @param side the checkbox placement
                # 
                method add_checkbox {f name label {side "top"}}

                ##
                # @brief Adds a radiobutton  
                #
                # @param f the frame for radiobutton 
                # @param name the radiobutton name
                # @param y the radiobox vertical distance from other widgets
                # @param side the radiobutton placement
                # @param orient the radiobutton orientation
                # @param labelpos the radiobutton label position
                # @param text the radiobutton label
                # 
                method add_radiobox {f name {y 0} {side "top"} \
                        {orient "horizontal"} {labelpos "w"} {text ""} \
                        {fg "black"}}

                ##
                # @brief Adds a field in Scheduling Annotation screen
                #
                # @param f the frame for the field
                # @param n1 the first method name
                # @param n2 the second method name
                #
                method add_schedule_annotation_field {f n1 n2}

                ##
                # @brief Choose the default annotation between modules.
                #
                # @param l the list of methods
                # @param id1 the first method id
                # @param id2 the second method id
                #
                # @return returns the annotation name
                #
		method choose_default_annotation {l id1 id2}

                ##
                # @brief Set the settings in the fields of Input tab of the
                # Verilog Module Overview  
                #
                # @param id the id of field
                # @param name the field name
                # @param type the type of the port
                # @param range the range of the port
                # @param parent the parent widget name
                # 
                method set_add_verilog_input_field {id name type range parent}

                ##
                # @brief Set the settings in the fields of Output tab of the
                # Verilog Module Overview  
                #
                # @param id the id of field
                # @param name the field name
                # @param type the type of the port
                # @param range the range of the port
                # @param parent the parent widget name
                # 
                method set_add_verilog_output_field {id name type range parent}

                ##
                # @brief Set the settings in the fields of Inout tab of the
                # Verilog Module Overview  
                #
                # @param id the id of field
                # @param name the field name
                # @param range the range of the port
                # @param parent the parent widget name
                # 
                method set_add_verilog_inout_field {id name range parent}

                ##
                # @brief Sets the fields in Input clock tab of Bluespec Module
                # Definition screen
                #
                # @param fr the frame name of the field
                # @param frt the frame name of the top field in the field
                # @param name the name of the field
                # @param id the id of the field
                # @param parent the parent widget name
                # 
                method set_bluespec_input_clock_field {fr frt name id parent} 

                ##
                # @brief Sets the fields in Input reset tab of Bluespec Module
                # Definition screen
                #
                # @param fr the frame name of the field
                # @param frt the frame name of the top field in the field
                # @param name the name of the field
                # @param id the id of the field
                # @param parent the parent widget name
                # 
                method set_bluespec_input_reset_field {fr frt name id parent}

                ##
                # @brief Sets the fields in Inout tab of Bluespec Module
                # Definition screen
                #
                # @param name the name of the field
                # @param id the id of the field
                # @param parent the parent widget name
                # 
                method set_bluespec_inout_field {name id parent}

                ##
                # @brief Sets the Inout verilog port of Inout tab of Bluespec
                # Module Definition screen
                #
                # @param p the verilog port frame name
                #
                method set_bluespec_inout_verilog_port {p}

                ##
                # @brief Sets the Inout bluespec clock of Inout tab of Bluespec
                # Module Definition screen
                #
                # @param p the bluespec clock frame name
                #
                method set_bluespec_inout_bluespec_clock {p}

                ##
                # @brief Sets the Inout bluespec reset of Inout tab of Bluespec
                # Module Definition screen
                #
                # @param p the bluespec reset frame name
                #
                method set_bluespec_inout_bluespec_reset {p}

                ##
                # @brief Sets the settings of Value Methods
                #
                # @param name the name of the method
                # @param id the id of the method
                #
                method set_value_method_default {name id}

                ##
                # @brief Sets the Method bindings default clock and reset
                #
                # @param id the id of the method
                #
                method set_method_default_clock_reset {id}

                ##
                # @brief Sets the settings in Method bindings section
                #
                # @param id the id of the method
                #
                method set_method_binding_settings {id}

                ##
                # @brief Sets the settings for Method binding section
                #
                # @param name the name of the interface
                # @param parent the parent widget name
                # @param id the id of the method
                # @param type the type of the method
                #
                method set_create_method_bindings {id name parent type}

                ##
                # @brief Sets the settings for interface binding section
                #
                # @param name the name of the interface
                # @param parent the parent widget name
                # @param id the id of the interface
                #
                method set_create_interface_bindings {id name parent}

                ##
                # @brief Insert the method name in the Port/Method/Subinterface
                # list
                #
                # @param text the text to be inserted
                # @param parent the parent widget name
                # @param id the id of the method
                # @param name the port name
                #
                method insert_method_after_parent {id text parent name}

                ##
                # @brief Insert the interface name in the
                # Port/Method/Subinterface list
                #
                # @param text the text to be inserted
                # @param parent the parent widget name
                # @param id the id of the interface
                #
                method insert_interface_after_parent {id text parent}

                ##
                # @brief Recreates the Method Port binding screen
                #
                method rebuild_method_port_binding {}

                ##
                # @brief Writes the definitions of interface into a temporary
                # file
                #
                # @param id the id of the file to be written
                #
                method write_interface_into_file {id}

                ##
                # @brief Writes the definitions of subinterfaces in the
                # interface definiton into a temporary file
                #
                # @param p_ifc the frame name of the parent interface
                # @param id the id of the file to be written
                #
                method write_subinterface_into_interface {p_ifc id}

                ##
                # @brief Writes the definitions of methods in the interface
                # definiton into a temporary file
                #
                # @param mname the frame name of the method
                # @param id the id of the file to be written
                #
                method write_methods_into_interface {mname id}

                ##
                # @brief Writes the definitions of import BVI into a temporary
                # file
                #
                # @param id the id of the file to be written
                #
                method write_import_bvi_into_file {id}

                ##
                # @brief Writes the definitions of interfaces and methods in
                # the import bvi definiton into a temporary file
                #
                # @param id the id of the file to be written
                #
                method write_interface_method_into_import_bvi {id}

                ##
                # @brief Writes the definitions of subinterfaces in the import
                # bvi definiton into a temporary file
                #
                # @param p_ifc the frame name of the parent interface
                # @param id the id of the file to be written
                #
                method write_subinterface_into_import_bvi {p_ifc id}

                ##
                # @brief Writes the port bindings into a temporary file
                #
                # @param id the id of the file to be written
                #
                method write_port_bindings_into_import_bvi {id}

                ##
                # @brief Writes the definitions of default clock/reset in the
                # import bvi definition into a temporary file
                #
                # @param id the id of the file to be written
                #
                method write_default_clock_reset_into_import_bvi {id}

                ##
                # @brief Writes the definitions of input clock in the
                # import bvi definition into a temporary file
                #
                # @param id the id of the file to be written
                #
                method write_input_clock_into_import_bvi {id}

                ##
                # @brief Writes the definitions of input reset in the
                # import bvi definition into a temporary file
                #
                # @param id the id of the file to be written
                #
                method write_input_reset_into_import_bvi {id}

                ##
                # @brief Writes the definitions of inouts in the import bvi
                # definition into a temporary file
                #
                # @param id the id of the file to be written
                #
                method write_inout_into_import_bvi {id}

                ##
                # @brief Writes the definitions of methods in the inport BVI
                # definition into a temporary file
                #
                # @param mname the frame name of the method
                # @param id the id of the file to be written
                # @param tab the tab symbol to be displayed before method
                # definition in the file
                #
                method write_methods_into_import_bvi {mname id {tab ""}}

                ##
                # @brief Writes the combinational paths into a temporary file
                #
                # @param id the id of the file to be written
                #
                method write_combinational_path_into_file {id}

                ##
                # @brief Writes the scheduling annotation into a temporary file
                #
                # @param id the id of the file to be written
                #
                method write_scheduling_annotation_into_file {id}

                ##
                # @brief Gets the checkbutton name
                #
                # @param list the sub list of interfaces
                #
                # @return last interface or method checkbutton name
                #
                method get_interface_last_checkbutton {list}

                ##
                # @brief Gets the module inside of interface name
                #
                # @param mname the name of the method frame
                #
                # @return interface name
                #
                method get_method_parent {fr}

                ##
                # @brief Gets the verilog module overview tab index
                #
                # @param l1 the list index
                #
                method get_tab_index {l1}

                ##
                # @brief Gets the current checked method id
                #
                # @param mn the name of the method
                #
                # @return current method id
                #
                method get_current_method_id {mn}

                ##
                # @brief Gets the current frame level
                #
                # @param frame the frame name
                #
                # @return frame level
                #
                method get_propagate_level {frame}

                ##
                # @brief Gets the current loaded interface names
                #
                # @return interface names
                #
                method get_loaded_interfaces {}

                ##
                # @brief Gets the port frame name
                #
                # @param list the frame list
                # @param name the port name
                #
                # @return frame name
                #
                method get_port_frame {list name}

                ##
                # @brief Removes the interfaces which have no method/interface 
                #
                # @param list the initial list 
                #
                method remove_leaf_interface {list}

                ##
                # @brief Removes the interfaces which are defined in imported
                # packages  
                #
                method remove_interface_from_imported_package {}

                ##
                # @brief Removes the wizard all information 
                #
                method reset_wizard {}

                ##
                # @brief Sets the bindings
                #
                # @param name the object name
                #
                method set_bindings {name}

                ##
                # @brief Sets the bindings
                #
                # @param fr the entryfield frame name
                #
                method set_name_bindings {fr}

                ##
                # @brief Sets the binding for paned window
                #
                # @param id the pane id
                #
                method set_binding_for_pane {id}

                ##
                # @brief Sets the binding for the wizard window
                #
                method set_wizard_bindings {}

                ##
                # @brief Sets the binding for the numbering text frame 
                #
                method set_show_number_binding {}

                ##
                # @brief Print current status
                #
                method print_status {type}

                ##
                # @brief Deletes the given frame and removes it's name from the
                # list
                #
                # @param name the component name which will deleted
                #
                method remove_subinterface_from_list {name}

                ##
                # @brief Deletes the given frame and removes it's name from the
                # list
                #
                # @param name the component name which will deleted
                #
                method delete_method_port_interface {name}

                ##
                # @brief Deletes the given frame and removes it's name from the
                # list
                #
                # @param name the component name which will deleted
                #
                method remove_method_from_list {name}

                ##
                # @brief Calculate all unused ports from all ports list
                #
                # @param list the all ports list
                #
                # @return all unused ports list
                #
                method calculate_unused_ports {list}

                ##
                # @brief Gets all verilog ports except clocks and resets
                #
                # @return all ports list
                #
                method get_all_verilog_ports {}

                ##
                # @brief Show the counts of existing methods and subinterfaces
                #
                method show_number_methods_subinterfaces {}

                ##
                # @brief Show the unused input(s), output(s) and inout(s) ports
                # in "Show info" field
                #
                # @param list the unused ports list
                #
                method show_unused_inputs_outputs_inouts {list}
                method check_regexp { entry }
        }

        constructor {args} {
                global BSPEC
                set win $BSPEC(IMPORT_BVI)
                catch "unset SCHED_ANNOTATION"
                array set SCHED_ANNOTATION_TMP [list]
                create_menubar
                add_frame $itk_interior frame
                create_action_buttons 
                create_verilog_module_window
                set_wizard_bindings
                eval itk_initialize $args
                catch "unset  [namespace current]::SCHED_ANNOTATION"
                array set  [namespace current]::SCHED_ANNOTATION [list]
                wm protocol $win WM_DELETE_WINDOW "$win action_close"
        }

        destructor {}
}

itcl::body import_bvi_wizard::create_menubar {} {
        itk_component add menu {
                base::menubar $itk_interior.menu -helpvariable helpVar \
                        -cursor "" 
        } {
                keep -activebackground -cursor
        }
        create_wizard_menu
        create_help_menu 
        pack $itk_component(menu) -fill x 
}

itcl::body import_bvi_wizard::create_wizard_menu {} {
        $itk_component(menu) add menubutton wizard -text "Wizard" \
        -underline 0 -menu {
                global BSPEC
                set t $BSPEC(IMPORT_BVI)
                options -tearoff false -postcommand "$t open_wizard_menu"
                command vmo -label "Verilog module overview" -underline 0 \
                        -helpstr "Opens the first step of the wizard" \
                        -state normal -command "$t action_switch vfr"
                command bmd -label "Bluespec module definition" -underline 0 \
                        -helpstr "Opens the second step of the wizard" \
                        -state normal -command "$t action_switch bmfr"
                command mpb -label "Method port binding" -underline 0 \
                        -helpstr "Opens the third step of the wizard" \
                        -state normal -command "$t action_switch mpfr"
                command cp -label "Combinational path" -underline 14 \
                        -helpstr "Opens the fourth step of the wizard" \
                        -state normal -command "$t action_switch cpfr"
                command sa -label "Scheduling annotations" -underline 0 \
                        -helpstr "Opens the fifth step of the wizard" \
                        -state normal -command "$t action_switch safr"
                command finish -label "Finish" -underline 0 \
                        -helpstr "Opens the last step of the wizard" \
                        -state normal -command "$t action_switch ffr"
                command close -label "Close" -underline 0 \
                        -helpstr "Closes the Import BVI Wizard" \
                        -state normal -command "$t action_cancel"
        }
}

itcl::body import_bvi_wizard::create_help_menu {} {
        $itk_component(menu) add menubutton view -text "Help" \
        -underline 0 -menu {
                options -tearoff false \
                        -postcommand {}
        }
}

itcl::body import_bvi_wizard::create_action_buttons {} {
        add_frame $itk_interior bframe 0 0 bottom false
        add_frame $itk_component(bframe) brframe 0 0 top false
        set c $itk_component(brframe)
        set width 7
        set y 2
        canvas $c.sp1 -width 2000 -height 1
        $c.sp1 create line 0 1 2000 1 -fill black
        pack $c.sp1 -pady 5 -padx 5 
        add_label $c step_status "" 2 0 left false 
        add_status_component $c status istatus left
        add_button $c cancel "Cancel" "$this action_cancel" $width $y right
        add_button $c next "Next ->" "$this action_next" $width $y right
        add_button $c show "Show" "$this action_show" $width $y right
        add_button $c check "Check" "$this action_check 1" $width $y right
        add_button $c back "<- Back" "$this action_back" $width $y right
}

itcl::body import_bvi_wizard::create_verilog_module_window {{action ""}} {
        switch [hide_screens vfr $action] {
                0 {
                        add_frame $itk_component(frame) vfr
                        create_verilog_buttons
                        create_verilog_overview
                        lappend screens vfr
                }
                2 {
                        set bluespec_parameter_binding_temp \
                                $bluespec_parameter_binding
                        pack $itk_component(vfr) -fill both -expand true
                }
        } 
        set current_screen vfr
        $itk_component(step_status) configure -text \
                "Verilog Module Overview   1 of 6"
        $itk_component(next) configure -text "Next ->" -state normal
        $itk_component(check) configure -state normal
        $itk_component(show) configure -state disabled
}

itcl::body import_bvi_wizard::create_verilog_buttons {} {
        add_frame $itk_component(vfr) vbfr 5 5 left false
        set c $itk_component(vbfr)
        set w 12
        set y 8
        add_button $c open_verilog "Read Verilog" "$this open_verilog 1" $w $y
        add_button $c read_file "Read From File" "$this open_verilog 0" $w $y
        add_button $c save_file "Save List To File" \
                        "$this save_list_to_file" $w $y
}

itcl::body import_bvi_wizard::create_verilog_overview {} {
        add_frame $itk_component(vfr) vofr 0 0 right
        set c $itk_component(vofr)
        add_combobox $c vomn "Module name" 10
        create_verilog_overview_tabnotebook
        create_verilog_overview_parameter_tab
        create_verilog_overview_input_tab
        create_verilog_overview_output_tab
        create_verilog_overview_inout_tab
}

itcl::body import_bvi_wizard::create_verilog_overview_tabnotebook {} {
        itk_component add votab {
                base::tabnotebook $itk_component(vofr).votab
        } {
                keep -cursor -background
        }
        $itk_component(votab) configure -pady 2 -padx 40 -borderwidth 2 \
                -tabpos n -equaltabs true
        pack $itk_component(votab) -fill both -expand yes
}

itcl::body import_bvi_wizard::create_verilog_overview_parameter_tab {} {
        set pname_tab [$itk_component(votab) add_label "Parameters"]
        add_scrolledframe $pname_tab param_fr ""
        add_frame [$itk_component(param_fr) childsite] param_lbfr
        pack $itk_component(param_lbfr) -ipadx 95
        set cs $itk_component(param_lbfr)
        add_label $cs param_lfr "  Name" 0 0 left
        add_label $cs param_rfr "  Range/Type" 0 0 left
        add_button $cs "vp_add_bt" "Add +" "$this add_verilog_parameter_field \
                verilog_param param_lbfr" 3 1 left 
        $itk_component(votab) select 0
}

itcl::body import_bvi_wizard::create_verilog_overview_input_tab {} {
        set input_tab [$itk_component(votab) add_label "Inputs"]
        add_scrolledframe $input_tab input_fr ""
        add_frame [$itk_component(input_fr) childsite] input_lbfr
        pack $itk_component(input_lbfr) -ipadx 113
        set cs $itk_component(input_lbfr)
        add_label $cs input_nfr "    Name" 0 0 left
        add_label $cs input_rfr "            Range" 0 0 left
        add_label $cs input_tfr "    Clock | Clock gate | Reset | None" \
                0 0 left
        add_button $cs "vin_add_bt" "Add +" "$this add_verilog_input_field \
                 verilog_inp input_lbfr" 3 1 left 
}

itcl::body import_bvi_wizard::create_verilog_overview_output_tab {} {
        set output_tab [$itk_component(votab) add_label "Outputs"]
        add_scrolledframe $output_tab output_fr ""
        add_frame [$itk_component(output_fr) childsite] output_lbfr
        pack $itk_component(output_lbfr) -ipadx 85
        set cs $itk_component(output_lbfr)
        add_label $cs output_nfr "        Name" 0 0 left
        add_label $cs output_rfr "               Range" 0 0 left
        add_label $cs output_tfr "         Clock | Clock gate\
                | Reset | Registered | None" 0 0 left
        add_button $cs "vout_add_bt" "Add +" "$this add_verilog_output_field \
                verilog_out output_lbfr" 3 1 left 
}

itcl::body import_bvi_wizard::create_verilog_overview_inout_tab {} {
        set inout_tab [$itk_component(votab) add_label "Inouts"]
        add_scrolledframe $inout_tab inout_fr ""
        add_frame [$itk_component(inout_fr) childsite] inout_lbfr
        pack $itk_component(inout_lbfr) -ipadx 113
        set cs $itk_component(inout_lbfr)
        add_label $cs inout_nfr " Name" 0 0 left
        add_label $cs inout_rfr "  Range " 0 0 left
        add_button $cs "vinout_add_bt" "Add +" "$this add_verilog_inout_field \
                verilog_inout inout_lbfr" 3 1 left
}

itcl::body import_bvi_wizard::create_bluespec_module_window {{action ""}} {
        switch [hide_screens bmfr $action] {
                0 {
                        add_frame $itk_component(frame) bmfr
                        create_bluespec_module_left
                        create_bluespec_module_right
                        set_bluespec_module_values
                        lappend screens bmfr
                }
                1 {
			pack $itk_component(bmfr) -fill both -expand true
                        set_bluespec_module_window
                }
                2 {
                        $itk_component(bmi) clear
                        $itk_component(bmi) insert 0 [get_interface_name]
			pack $itk_component(bmfr) -fill both -expand true
                }

        }
        set current_screen bmfr
        $itk_component(step_status) configure -text \
                "Bluespec Module Definition   2 of 6"
        $itk_component(back) configure -state normal
        $itk_component(check) configure -state normal
        $itk_component(show) configure -state normal
        $itk_component(next) configure -text "Next ->" -state normal
}

itcl::body import_bvi_wizard::create_bluespec_module_left {} {
        add_frame $itk_component(bmfr) bmlfr 5 0 left false
        add_entryfield $itk_component(bmlfr) bmn "Module name" 5 0 top false \
                "#0000ff"
        add_frame $itk_component(bmlfr) bmifr 0 0 top false
        pack $itk_component(bmlfr) -ipadx 10
        add_entryfield $itk_component(bmifr) bmi "Interface type" 2 0 top \
                true "#0000ff"
        focus [$itk_component(bmi) component entry]
        add_radiobox $itk_component(bmifr) bmirb 5 left
        $itk_component(bmirb) add bmirdfm -pady 10 -text "Define From Method" \
                -command "$this set_interface_type dfm bmfr" \
                -highlightthickness 1
        $itk_component(bmirb) add bmirue -pady 10 -text "Use Existing" \
                -command "$this set_interface_type ue bmfr" \
                -highlightthickness 1
        add_button $itk_component(bmifr) bmb_bt "Browse..." \
                "$this set_interface" 5 10 left 
        $itk_component(bmirb) select 0
        iwidgets::Labeledwidget::alignlabels $itk_component(bmn) \
                                                $itk_component(bmi)
        add_scrolledframe $itk_component(bmlfr) pckg_import_fr "" top 0 0 \
                false none none
        pack $itk_component(pckg_import_fr) -ipady 3
        add_frame [$itk_component(pckg_import_fr) childsite] pckg_import_lbfr
        pack $itk_component(pckg_import_lbfr) -ipadx 107
        set cs $itk_component(pckg_import_lbfr)
        add_label $cs pckg_import_lfr "Package import " 0 0 left
        add_button $cs "pckg_import_add_bt" "Add +" \
                "$itk_component(pckg_import_fr) configure -vscrollmode dynamic;\
                $this add_bluespec_package_import_field pckg_import $cs" \
                3 1 right 
        add_scrolledframe $itk_component(bmlfr) provisos_fr "" top 0 0 \
                false none none
        pack $itk_component(provisos_fr) -ipady 3
        add_frame [$itk_component(provisos_fr) childsite] provisos_lbfr
        pack $itk_component(provisos_lbfr) -ipadx 129
        set cs $itk_component(provisos_lbfr)
        add_label $cs provisos_lfr "Provisos" 0 0 left
        add_button $cs "provisos_add_bt" "Add +" \
                "$itk_component(provisos_fr) configure -vscrollmode dynamic;\
                $this add_bluespec_provisos_field provisos_add_bt $cs" \
                3 1 right
        add_scrolledframe $itk_component(bmlfr) module_args_fr \
                "Bluespec module arguments" top 0 0 true none none
        pack $itk_component(module_args_fr) -ipadx 90
        add_frame [$itk_component(module_args_fr) childsite] module_args_lbfr
        pack $itk_component(module_args_lbfr) -ipadx 121
        set cs $itk_component(module_args_lbfr)
        add_label $cs module_args_lfr "Type" 0 0 left
        add_label $cs module_args_rfr "Name   " 0 0 left
        add_button $cs "bma_add_bt" "Add +" \
                "$itk_component(module_args_fr) configure -vscrollmode dynamic;\
                $this add_bluespec_module_args_field bmodul_arg $cs" 3 1 left
}

itcl::body import_bvi_wizard::create_bluespec_module_right {} {
        add_frame $itk_component(bmfr) bmrfr 5 0 right true
        create_bluespec_module_tabnotebook
        create_bluespec_module_parameter_binding_tab
        create_bluespec_module_input_clock_tab
        create_bluespec_module_input_reset_tab
        create_bluespec_module_inout_tab
}

itcl::body import_bvi_wizard::create_bluespec_module_tabnotebook {} {
        itk_component add bmtab {
                base::tabnotebook $itk_component(bmrfr).bmtab
        } {
                keep -cursor -background
        }
        $itk_component(bmtab) configure -tabpos n
        pack $itk_component(bmtab) -fill both -expand yes -ipady 100 
}

itcl::body import_bvi_wizard::create_bluespec_module_parameter_binding_tab {} {
        set pbind_tab [$itk_component(bmtab) add_label "Parameter Binding"]
        add_scrolledframe $pbind_tab pbind_fr ""
        add_frame [$itk_component(pbind_fr) childsite] pbind_lbfr
        set cs $itk_component(pbind_lbfr)
        add_label $cs pbind_lfr "Verilog parameters" 0 0 left
        add_label $cs pbind_rfr "BSV expressions" 0 0 left
        pack $cs -ipadx 36
        $itk_component(bmtab) select 0
}

itcl::body import_bvi_wizard::create_bluespec_module_input_clock_tab {} {
        set iclock_tab [$itk_component(bmtab) add_label "Input Clocks"]
        add_scrolledframe $iclock_tab iclock_fr ""
        add_frame [$itk_component(iclock_fr) childsite] iclock_lbfr
        set lf $itk_component(iclock_lbfr)
#        pack $itk_component(iclock_lbfr) -ipadx 134
#        add_label $lf ibc_name "BSV clock" 0 0 left
#        add_label $lf iv_clock "Verilog clock" 0 0 left
#        add_label $lf iv_clock_gate "Verilog clock gate" 0 0 left
#        add_label $lf idef_clock "Default" 0 0 left
#        add_label $lf ic_expression "Expression" 0 0 left
        add_button $lf "bic_add_bt" "Add +" \
                "$this add_bluespec_input_clock_field binp_clock $lf" 3 1 left
}

itcl::body import_bvi_wizard::create_bluespec_module_input_reset_tab {} {
        set ireset_tab [$itk_component(bmtab) add_label "Input Resets" \
                "$this set_bluespec_input_reset"]
        add_scrolledframe $ireset_tab ireset_fr ""
        add_frame [$itk_component(ireset_fr) childsite] ireset_lbfr
        set lf $itk_component(ireset_lbfr)
#        pack $itk_component(ireset_lbfr) -ipadx 123
#        add_label $lf rbc_name "BSV reset" 0 0 left
#        add_label $lf rv_clock "Verilog reset" 0 0 left
#        add_label $lf rv_clock_gate "Bluespec clock" 0 0 left
#        add_label $lf rdef_reset "Default" 0 0 left
#        add_label $lf rc_expression "Expression" 0 0 left
        add_button $lf "bir_add_bt" "Add +" \
                "$this add_bluespec_input_reset_field binp_reset $lf" 3 1 left
}

itcl::body import_bvi_wizard::create_bluespec_module_inout_tab {} {
        set binout_tab [$itk_component(bmtab) add_label "Inouts" \
                "$this set_bluespec_inout"]
        add_scrolledframe $binout_tab binout_fr ""
        add_frame [$itk_component(binout_fr) childsite] binout_lbfr
        pack $itk_component(binout_lbfr) -ipadx 126
        set lf $itk_component(binout_lbfr)
        add_label $lf bi_verilog_port "Verilog port" 0 0 left
        add_label $lf bi_clock "           Bluespec clock" 0 0 left
        add_label $lf bi_reset "      Bluespec reset" 0 0 left
        add_label $lf bi_expression "       Expression   " 0 0 left
        add_button $lf "bi_add_bt" "Add +" \
                "$this add_bluespec_inout_field b_inout $lf" 3 1 left
}

itcl::body import_bvi_wizard::create_method_port_window {{action ""}} {
        switch [hide_screens mpfr $action] {
                0 {
                        set bluespec_parameter_binding_temp \
                                $bluespec_parameter_binding
                        add_frame $itk_component(frame) mpfr
                        create_method_port
			lappend screens mpfr
                }
                1 {
                        set bluespec_parameter_binding_temp \
                                $bluespec_parameter_binding
			pack $itk_component(mpfr) -fill both -expand true
                        set_method_port_window
                }
                2 {
			pack $itk_component(mpfr) -fill both -expand true
                }
        }
        set current_screen mpfr
        $itk_component(step_status) configure -text \
                "Method Port Binding   3 of 6"
        $itk_component(back) configure -state normal
        $itk_component(check) configure -state normal
        $itk_component(show) configure -state normal
        $itk_component(next) configure -text "Next ->" -state normal
}

itcl::body import_bvi_wizard::create_method_port {} {
        add_frame $itk_component(mpfr) mpbtfr 0 0 top false
        add_frame $itk_component(mpbtfr) mpifr 0 0 top false
        add_entryfield $itk_component(mpifr) mpi "Interface type" 5 0 left \
                true "#0000ff"
        focus [$itk_component(mpi) component entry]
        add_radiobox $itk_component(mpifr) mb_rb 0 left 
        $itk_component(mb_rb) add mb_rb_mirdfm -pady 5 \
                -text "Define From Method" -highlightthickness 1 \
                -command "$this set_interface_type dfm mpfr"
        $itk_component(mb_rb) add mb_rb_mirue -pady 5 \
                -text "Use Existing" -highlightthickness 1 \
                -command "$this set_interface_type ue mpfr"

        add_button $itk_component(mpifr) mpb_bt "Browse..." \
                "$this set_interface" 10 0 left 
        $itk_component(mpi) clear
        $itk_component(mpi) insert 0 [get_bluespec_interface_name]
        itk_component add mppane {
               base::panedwindow $itk_component(mpfr).mppane -orient vertical
        } 
        $itk_component(mppane) add "left" -margin 0 -minimum 15
        set lpane [$itk_component(mppane) childsite "left"]
        $itk_component(mppane) add "middle" -margin 0 -minimum 70
        set mpane [$itk_component(mppane) childsite "middle"]
        $itk_component(mppane) add "right" -margin 0 -minimum 15
        set rpane [$itk_component(mppane) childsite "right"]

        $itk_component(mppane) fraction 15 85 0 
        pack $itk_component(mppane) -padx 0 -pady 0 -fill both -expand yes \
                -side top
        add_checkbox $lpane port_meth_ifc "Port/Method/Subinterface"
        add_button $lpane pms_hide_bt "Hide" \
                "$this hide_bindings" 10 0 bottom
        add_button $lpane pms_remove_bt "Remove Selected" \
                "$this remove_bindings" 10 0 bottom
        add_button $lpane pms_deselect_all_bt "Deselect All" \
                "$this deselect_all_bindings" 10 0 bottom
        add_button $lpane pms_select_all_bt "Select All" \
                "$this select_all_bindings" 10 0 bottom 

        add_scrolledframe $mpane mp_pmib_sfr ""
        set csfr [$itk_component(mp_pmib_sfr) childsite]
        add_frame $csfr mpi_propagate_0
        pack propagate $itk_component(mpi_propagate_0) 0
        lappend propagate_list "mpi_propagate_0 0"
        set csfr $itk_component(mpi_propagate_0)
        add_scrolledlistbox $rpane mp_up_slb ""
        add_button $rpane hide "Hide" "$this hide_unused_ports" 10 0 bottom
        add_button $itk_component(mpbtfr) mp_addpb_bt "Add Port Binding" \
                "$this create_port_bindings_frame $csfr" 13 5 left
        add_button $itk_component(mpbtfr) mp_addmeth_bt "Add Method" \
                "$this create_method_bindings_frame $csfr" 13 5 left
        add_button $itk_component(mpbtfr) mp_addint_bt "Add Interface" \
                "$this create_interface_bindings_frame $csfr" 13 5 left
        add_button $itk_component(mpbtfr) mp_show_hierarchy \
                "Show hierarchy" "$this show_hierarchy_ports" 15 5 left
        add_button $itk_component(mpbtfr) mp_show_unused_port \
                "Show info" "$this show_info_field" 15 5 left
        add_button $itk_component(mpbtfr) build_skelet \
                "Build Skeleton" "$this build_skeleton \
                mpi_propagate_0" 22 7 right
        add_button $itk_component(mpbtfr) auto_create "Auto Create From \
                Verilog" "$this auto_create_from_verilog" 22 7 right
        if {[$itk_component(bmirb) get] == "bmirdfm"} {
                $itk_component(mb_rb) select 0
        } else {
                $itk_component(mb_rb) select 1
        }
}

itcl::body import_bvi_wizard::rebuild_method_port_binding {} {
        destroy $itk_component(mp_pmib_sfr)
        destroy $itk_component(port_meth_ifc)
        destroy $itk_component(mp_up_slb)
        array set METHOD_BINDING_ARGS ""
        foreach i "port_binding method_bindings method_port_bindings \
                                        interface_binding propagate_list" {
                set $i ""
        }
        set lpane [$itk_component(mppane) childsite "left"]
        set mpane [$itk_component(mppane) childsite "middle"]
        set rpane [$itk_component(mppane) childsite "right"]
        add_checkbox $lpane port_meth_ifc "Port/Method/Subinterface"
        add_scrolledframe $mpane mp_pmib_sfr "" top 0 0 true dynamic
        set csfr [$itk_component(mp_pmib_sfr) childsite]
        add_frame $csfr mpi_propagate_0
        pack propagate $itk_component(mpi_propagate_0) 0
        lappend propagate_list "mpi_propagate_0 0"
        add_scrolledlistbox $rpane mp_up_slb ""
}

itcl::body import_bvi_wizard::create_port_bindings_frame {f {name ""}} {
        set_method_port_interface_size "" "port" "+" $f
        set id 0
        while {[lsearch $method_port_bindings mb_port_fr_$id] != -1} {
                incr id
        }
        add_labeledframe $f mb_port_fr_$id "Port bindings" 0 0 top \
                true nw groove
        lappend method_port_bindings mb_port_fr_$id
        if {$name != ""} {
                pack forget $itk_component(mb_port_fr_$id)
        }
        add_scrolledframe [$itk_component(mb_port_fr_$id) childsite] \
                mb_pmsfr_$id "" 
        set cs [$itk_component(mb_pmsfr_$id) childsite]
        add_frame $cs mb_pmlbfr_$id
        set lf $itk_component(mb_pmlbfr_$id)
        pack $itk_component(mb_pmlbfr_$id) -ipadx 68
        add_label $lf mb_pmvnlfr_$id "Verilog name" 0 0 left
        add_label $lf mb_pmbelfr_$id "BSV expression    " 0 0 left
        add_button $lf "pb_add_bt_$id" "Add +" "$this add_port_binding_field \
                $cs port_bind $lf $id" 3 1 left 

        if {$name == ""} {
                set name "unknown"
        	set text "Port $id"
        } else {
        	set text "Port $name"
                foreach i [get_verilog_input] {
                        add_port_binding_field $cs [lindex $i 0] "" $id
                }
        }
        set ch $itk_component(port_meth_ifc)
        $ch add mb_port_ch_$id -padx 0 -pady 2 -text $text \
                -highlightthickness 1 -highlightbackground white
        if {$name == "unknown"} {
                $ch select mb_port_ch_$id
        }
        $ch buttonconfigure mb_port_ch_$id -command "$this \
        show_method_port_ifc mb_port_ch_$id mb_port_fr_$id method_port_bindings"
        $itk_component(mp_addmeth_bt) configure -state normal
}

itcl::body import_bvi_wizard::create_interface_bindings_frame {f {name ""} \
                                                                {parent ""}} {
        set id 0
        while {[lsearch -index 0 $interface_binding mb_subi_fr_$id] != -1} {
                incr id
        }
        add_labeledframe $f mb_subi_fr_$id "Subinterface bindings" 0 0 top \
		true nw groove
        pack $itk_component(mb_subi_fr_$id) -fill x
        if {$name != ""} {
                pack forget $itk_component(mb_subi_fr_$id)
        } else {
                if {$parent != ""} {
                        set_method_port_interface_size $itk_component($parent) \
                                "interface" "+" ""
                } else {
                        set_method_port_interface_size "" "interface" "+" $f
                }
        }
        set cs [$itk_component(mb_subi_fr_$id) childsite]
        add_frame $cs mp_si_ntb_fr_$id 
## TODO Break into pieces
################## Create a pane for interface ###################
        itk_component add ipane_$id {
               base::panedwindow $cs.ipane_$id -orient horizontal
        } 
        $itk_component(ipane_$id) add top -margin 0 -minimum 0
        set top [$itk_component(ipane_$id) childsite top]
        $itk_component(ipane_$id) add bottom -margin 0 -minimum 0
        set bottom [$itk_component(ipane_$id) childsite bottom]
        $itk_component(ipane_$id) fraction 100 0
        add_scrolledframe $top mb_sub_pmbind_$id "" bottom 0 0 true dynamic
##############
        add_frame [$itk_component(mb_sub_pmbind_$id) childsite] \
                mb_subi_propagate_$id
        pack propagate $itk_component(mb_subi_propagate_$id) 0
        if {$parent == ""} {
                lappend propagate_list "mb_subi_propagate_$id 1"
        } else {
                set ind [lsearch -index 0 $propagate_list [regsub "_fr_" \
                        $parent "_propagate_"]]
                set level [lindex [lindex $propagate_list $ind] 1]
                incr level
                lappend propagate_list "mb_subi_propagate_$id $level"
        }
##############
        set cssc $itk_component(mb_subi_propagate_$id)
        pack $itk_component(ipane_$id) -padx 0 -pady 0 -fill both -expand yes \
                -side top -ipady 100
        set_binding_for_pane $id
##################################################################
        pack $itk_component(mb_sub_pmbind_$id) -ipadx 370 -ipady 5
        add_frame $itk_component(mp_si_ntb_fr_$id) mb_subi_name_fr_$id \
                10 0 top
        add_frame $itk_component(mp_si_ntb_fr_$id) mb_subi_type_fr_$id \
                10 0 top
        add_entryfield $itk_component(mb_subi_name_fr_$id) \
                mb_subi_name_$id "Name" 5 0 left false #0000ff
        focus [$itk_component(mb_subi_name_$id) component entry]
        $itk_component(mb_subi_name_$id) insert 0 $name
        add_entryfield $itk_component(mb_subi_type_fr_$id) \
                mb_subi_type_$id "Type" 5 0 left false #0000ff 
        iwidgets::Labeledwidget::alignlabels \
                $itk_component(mb_subi_name_$id) \
		$itk_component(mb_subi_type_$id)
        add_button $itk_component(mb_subi_name_fr_$id) mp_addmeth_bt_1_$id \
		"Add Method" "$this create_method_bindings_frame $cssc \
                \"\" \"\"\ mb_subi_fr_$id" 12 5 left
        add_button $itk_component(mb_subi_name_fr_$id) mp_addint_bt_1_$id \
		"Add Interface" "$this create_interface_bindings_frame \
		$cssc \"\"\ mb_subi_fr_$id"  12 5 left
        add_button $itk_component(mb_subi_name_fr_$id) mb_addrcino_bt_$id \
		"" "" 12 7 left
        add_radiobox $itk_component(mb_subi_type_fr_$id) mb_sirb_$id 5 left 
        $itk_component(mb_sirb_$id) add bmb_sirb_mirdfm_$id -pady 5 \
                -text "Define From Method" -highlightthickness 1 \
                -command "$this set_subinterface_type dfm $id"
        $itk_component(mb_sirb_$id) add bmb_sirb_mirue_$id -pady 5 \
                -text "Use Existing" -highlightthickness 1 \
                -command "$this set_subinterface_type ue $id"
        add_button $itk_component(mb_subi_type_fr_$id) bmb_sirb_mb_bt_$id \
                "Browse..." "$this set_interface $id" 15 5 left 
        add_button $itk_component(mb_subi_type_fr_$id) mb_subbsk_bt_$id \
                "Build Skeleton" "$this build_skeleton \
                mb_subi_propagate_$id mb_subi_fr_$id $top" 15 5 left
        $itk_component(mb_sirb_$id) select 0
        set_name_bindings mb_subi_name_$id
        set_create_interface_bindings $id $name $parent
}

itcl::body import_bvi_wizard::create_method_bindings_frame {f {name ""} \
                                        {type ""} {parent ""} {arg ""}} {
        $itk_component(mp_addmeth_bt) configure -state disabled
        set id 0
        while {[lsearch -index 0 $method_bindings mb_mb_fr_$id] != -1} {
                incr id
        }
        add_labeledframe $f mb_mb_fr_$id "Method bindings" \
                0 0 top true nw groove
        pack $itk_component(mb_mb_fr_$id) -fill x
        if {$name != ""} {
                pack forget $itk_component(mb_mb_fr_$id)
        } else {
                if {$parent != ""} {
                        set_method_port_interface_size $itk_component($parent) \
                                "method" "+" ""
                } else {
                        set_method_port_interface_size "" "method" "+" $f
                }
        }
        set c [$itk_component(mb_mb_fr_$id) childsite]
        add_frame $c mb_cbrbfr_$id 0 0 bottom 
        add_frame $c mb_rtrsfr_$id 0 0 bottom 
        add_frame $c mb_lfr_$id 0 0 left
        add_frame $c mb_rfr_$id 0 0 left

        add_entryfield $itk_component(mb_lfr_$id) mb_method_name_$id "Name" \
                2 10 top false #0000ff
        focus [$itk_component(mb_method_name_$id) component entry]
        add_frame $itk_component(mb_lfr_$id) mb_rcontfr_$id 
        add_radiobox $itk_component(mb_rcontfr_$id) mb_method_type_rb_$id \
		5 left vertical "w" "" "#0000ff"
        $itk_component(mb_method_type_rb_$id) add action -text "Action" \
                -command "$this method_binding_enable action $id" \
                -highlightthickness 1
        $itk_component(mb_method_type_rb_$id) add action_value -text \
                "ActionValue" -command "$this method_binding_enable \
                action_value $id" -highlightthickness 1
        $itk_component(mb_method_type_rb_$id) add value -text "Value" \
                -command "$this method_binding_enable value $id" \
                -highlightthickness 1
        add_frame $itk_component(mb_rcontfr_$id) mb_enrefr_$id 0 0 right
        add_combobox $itk_component(mb_enrefr_$id) mb_enable_cmb_$id "Enable" 2
        add_combobox $itk_component(mb_enrefr_$id) mb_ready_cmb_$id "Ready" 2 
        add_entryfield $itk_component(mb_rtrsfr_$id) mb_returnt_ent_$id \
		"Return type" 0 2 left false #0000ff 
        add_combobox $itk_component(mb_rtrsfr_$id) mb_returnp_cmb_$id \
		"       Return signal" 0 0 left
        add_combobox $itk_component(mb_cbrbfr_$id) mb_clock_cmb_$id \
		"Clocked by " 0 0 left "" #0000ff 
        add_combobox $itk_component(mb_cbrbfr_$id) mb_reset_cmb_$id \
		" Reset by         " 0 0 left "" #0000ff
## TODO Break into pieces
############# Create argument section in the method section###########
        add_scrolledframe $itk_component(mb_rfr_$id) mb_avmsfr_$id \
		Arguments left 10
        pack $itk_component(mb_avmsfr_$id) -ipadx 165
        set cs [$itk_component(mb_avmsfr_$id) childsite]
        add_frame $cs mb_avmlbfr_$id 0 0 top true
        pack $itk_component(mb_avmlbfr_$id) -ipadx 91
        set lf $itk_component(mb_avmlbfr_$id)
        add_label $lf mb_avmstlfr_$id "BSV type" 0 0 left
        add_label $lf mb_avmsvlfr_$id "Verilog name   " 0 0 left
	set METHOD_BINDING_ARGS($cs) ""
        add_button $lf "mpb_add_bt_$id" "Add +" "$this \
        add_method_binding_args_field $cs meth_bind mb_avmlbfr_$id" 3 1 left
        iwidgets::Labeledwidget::alignlabels \
                $itk_component(mb_enrefr_$id).mb_enable_cmb_$id \
                $itk_component(mb_enrefr_$id).mb_ready_cmb_$id    
        set_method_binding_settings $id
        set_method_default_clock_reset $id
########################################################################
        if {$type != ""} {
                if {[string tolower $type] == "action"} {
                        $itk_component(mb_method_type_rb_$id) select action
                        $itk_component(mb_enrefr_$id).mb_enable_cmb_$id \
                                component entry insert end "always enabled" 
                } elseif {[string tolower $type] == "value"} {
                        $itk_component(mb_method_type_rb_$id) select value
                        set_value_method_default $name $id
                } else {
                        $itk_component(mb_method_type_rb_$id) select value
                        $itk_component(mb_returnt_ent_$id) clear
                        $itk_component(mb_returnt_ent_$id) insert 0 $type
                }
                foreach a $arg {
                        add_method_binding_args_field $cs $a "" $a
                }
        }
        set_name_bindings mb_method_name_$id
        set_create_method_bindings $id $name $parent $type
}

itcl::body import_bvi_wizard::create_combinational_path_window {{action ""}} {
        switch [hide_screens cpfr $action] {
                0 {
                        add_frame $itk_component(frame) cpfr
                        create_combinational_path
                        lappend screens cpfr
                }
                1 {
			pack $itk_component(cpfr) -fill both -expand true
                        set_combinational_path_window
                }
                2 {
			pack $itk_component(cpfr) -fill both -expand true
                }
        }
        set current_screen cpfr
        $itk_component(step_status) configure -text \
                "Combinational Paths   4 of 6"
        $itk_component(back) configure -state normal
        $itk_component(check) configure -state normal
        $itk_component(show) configure -state normal
        $itk_component(next) configure -text "Next ->" -state normal
}

itcl::body import_bvi_wizard::create_combinational_path {} {
        add_scrolledframe $itk_component(cpfr) cp_pfr "" bottom 0 10 
        set cs [$itk_component(cp_pfr) childsite]
        add_frame $cs cp_plbfr 0 0 top
        pack $itk_component(cp_plbfr) -ipadx 440
        set lf $itk_component(cp_plbfr)
        add_label $lf cp_lfr "Paths" 0 0 left false
        add_button $lf "cp_add_bt" "Add +" "$this add_combinational_path_field \
                $cs c_path $lf" 3 1 left 
}

itcl::body import_bvi_wizard::create_scheduling_annotation_window {{action ""}} {
        switch [hide_screens safr $action] {
                0 {
                        set scheduling_annotation ""
                        add_frame $itk_component(frame) safr
                        generate_scheduling_annotations
                        create_scheduling_annotation_window_left
                        add_scrolledframe $itk_component(safr) sa_sfr \
                                "Scheduling annotations" left 5 0 true
                        pack $itk_component(sa_sfr) -ipady 223
                        lappend screens safr
                }
                1 {
                        set_scheduling_annotation_window
                }
                2 {
			pack $itk_component(safr) -fill both -expand true
                }
        }
        # Show the first page of annoations
        $this create_scheduling_annotation_window_right XXX 0

        set current_screen safr
        $itk_component(step_status) configure -text \
                "Scheduling Annotation   5 of 6"
        $itk_component(back) configure -state normal
        $itk_component(check) configure -state normal
        $itk_component(show) configure -state normal
        $itk_component(next) configure -text "Next ->" -state normal
}

itcl::body import_bvi_wizard::generate_scheduling_annotations {} {
        # reuse any annotation already set
        array set [namespace current]::SCHED_ANNOTATION [list]
        array unset SCHED_ANNOTATION_TMP 
        array set SCHED_ANNOTATION_TMP [array get  [namespace current]::SCHED_ANNOTATION]
        array unset  [namespace current]::SCHED_ANNOTATION
        

        set methodpairs [list]
        set methodlist [list]

	set list [get_method_binding]
        set rest [lassign $list head]
        while { $head != "" } {
                set n1 [lindex $head 1]
                set p1 [get_method_parent [lindex $head 0]]
                lappend methodlist $p1$n1
                set id1 [lindex [split [lindex $head 0] _] end]
                add_scheduling_annotations $p1$n1 $p1$n1 $list $id1 $id1
                foreach e $rest {
                        set n2 [lindex $e 1]
                        set p2 [get_method_parent [lindex $e 0]]
                        set id2 [lindex [split [lindex $e 0] _] end]
                        add_scheduling_annotations $p1$n1 $p2$n2 $list $id1 $id2
                }
                set rest [lassign $rest head]
        }
        array unset SCHED_ANNOTATION_TMP
}

itcl::body import_bvi_wizard::add_scheduling_annotations {m1 m2 list id1 id2} {
        set pair "$m1,$m2"
        if { [info exists SCHED_ANNOTATION_TMP($pair)] } {
                set an $SCHED_ANNOTATION_TMP($pair)
        } else {
                set an [choose_default_annotation $list $id1 $id2]
        }
        set  [namespace current]::SCHED_ANNOTATION($pair) $an
        lappend methodpairs $pair
}

itcl::body import_bvi_wizard::create_scheduling_annotation_window_left {} {
        add_frame $itk_component(safr) nav 2 10 left false
        add_labeledframe $itk_component(nav) filter "Filter Methods" 0 0 top \
                false nw groove
        set cs [$itk_component(filter) childsite]
        add_entryfield $cs filterm1 "method 1:"
        focus [$itk_component(filterm1) component entry]
        add_entryfield $cs filterm2 "method 2:"

        add_button $cs refresh Refresh \
                "$this create_scheduling_annotation_window_right XXX 0" 10 5 top normal "" true
        # populate the boxes
        $itk_component(filterm1) insert 0 ".*"
        $itk_component(filterm2) insert 0 ".*"
        $itk_component(filterm1) configure -command "$this create_scheduling_annotation_window_right XXX 0"
        $itk_component(filterm2) configure -command "$this create_scheduling_annotation_window_right XXX 0"


        add_labeledframe $itk_component(nav) pages "Paging" 0 0 top \
                false nw groove
        set cs [$itk_component(pages) childsite]
        add_combobox $cs page "Page:"
        # TODO figure out how manypages
        $cs.page insert list end 1 2 3 4 5
        $cs.page insert entry end 1
        add_combobox $cs lpp "Lines:" 
        $cs.lpp insert list end 15 20 30 50 100
        $cs.lpp insert entry 0 2
        add_button $cs prevp Prev \
                "$this create_scheduling_annotation_window_right -" 10 5 left
        add_button $cs nextp Next \
                "$this create_scheduling_annotation_window_right +" 10 5 right
        # Commands when the page field is changed
        $cs.page configure -command \
                "$this create_scheduling_annotation_window_right XXX 0"
        $cs.page configure -selectioncommand \
                "$this create_scheduling_annotation_window_right XXX 0"

        add_labeledframe $itk_component(nav) sizing "Stats" 0 0 top \
                false nw groove
        set cs [$itk_component(sizing) childsite]
        add_entryfield $cs tcount  "method pairs:"
        $itk_component(tcount) configure -textvariable import_bvi_wizard::TotalPairs \
            -state disabled -justify right
        add_entryfield $cs fmcount  "filtered pairs:"
        $itk_component(fmcount) configure -textvariable import_bvi_wizard::FilteredPairs \
            -state disabled -justify right
        add_entryfield $cs tpages  "total pages:"
        $itk_component(tpages) configure -textvariable import_bvi_wizard::TotalPages \
            -state disabled -justify right
        iwidgets::Labeledwidget::alignlabels  $itk_component(tcount) \
            $itk_component(fmcount) $itk_component(tpages)
}

itcl::body import_bvi_wizard::create_scheduling_annotation_window_right \
                                                        {action {type 1}} {
        start_process
        destroy $itk_component(sa_sfr)
        add_scrolledframe $itk_component(safr) sa_sfr "Scheduling annotations" \
                left 5 0 true
        pack $itk_component(sa_sfr) -ipady 223
        set cs [$itk_component(sa_sfr) childsite]
        set page [get_scheduling_annotation_current_page $action $type]
        foreach pair $page {
            lassign [split $pair ,] p1 p2
            add_schedule_annotation_field $cs $p1 $p2
        }
        finish_process
}

itcl::body import_bvi_wizard::add_schedule_annotation_field {f n1 n2} {
        set padx 50
	set name sa_$n1\_$n2
        set id [incr schedule_cnt]
        add_frame $f $name\_fr_$id 8
	lappend scheduling_annotation "$name\_fr_$id"

        add_entryfield $itk_component($name\_fr_$id) "$name\_lent_$id" "" \
		2 0 left false #0000ff
        pack $itk_component($name\_lent_$id) -ipadx $padx
        $itk_component($name\_lent_$id) insert 0 $n1 
        $itk_component($name\_lent_$id) configure -state readonly

        add_combobox $itk_component($name\_fr_$id) $name\_cmb_$id "" 0 0 \
                left "" Blue
        pack $itk_component($name\_fr_$id).$name\_cmb_$id -ipadx 2
        eval $itk_component($name\_fr_$id).$name\_cmb_$id insert \
                list end $sched_annotation_list
        $itk_component($name\_fr_$id).$name\_cmb_$id configure \
                -selectioncommand "$this set_new_annotation $n1 $n2 $id"
        $itk_component($name\_fr_$id).$name\_cmb_$id configure \
                -command "$this set_new_annotation $n1 $n2 $id"

        add_entryfield $itk_component($name\_fr_$id) "$name\_rent_$id" "" \
		2 0 left false #0000ff
        pack $itk_component($name\_rent_$id) -ipadx $padx
        $itk_component($name\_rent_$id) insert 0 $n2 
        $itk_component($name\_rent_$id) configure -state readonly

	set an [subst $[namespace current]::SCHED_ANNOTATION($n1,$n2)]
        $itk_component($name\_fr_$id).$name\_cmb_$id configure -textvariable  [namespace current]::SCHED_ANNOTATION($n1,$n2)

        $itk_component($name\_lent_$id) component entry configure -takefocus 0
        $itk_component($name\_rent_$id) component entry configure -takefocus 0
}

itcl::body import_bvi_wizard::create_finish_window {{action ""}} {
        $itk_component(check) configure -state disabled
        switch [hide_screens ffr $action] {
                0 {
                        add_frame $itk_component(frame) ffr
                        create_finish_window_top
                        create_finish_window_bottom
                        lappend screens ffr
                }
                1 {
			pack $itk_component(ffr) -fill both -expand true
                        set_finish_window
                }
        }
        set current_screen ffr
        $itk_component(step_status) configure -text "Finish   6 of 6"
        $itk_component(back) configure -state normal
        $itk_component(show) configure -state normal
        $itk_component(next) configure -text "Close" -state disabled
}

itcl::body import_bvi_wizard::create_finish_window_top {} {
        global BSPEC
        add_frame $itk_component(ffr) ftfr 0 10 top false
        add_entryfield $itk_component(ftfr) save_to_file "File to save" 5 0 \
                left false black
        focus [$itk_component(save_to_file) component entry]
        $itk_component(save_to_file) insert 0 \
                "bsv[get_bluespec_module_name]\.bsv"
        pack $itk_component(save_to_file) -ipadx 150
        add_button $itk_component(ftfr) select_file "Browse..." \
                "$this select_file" 10 0 left
        add_button $itk_component(ftfr) save_now "Save Now" \
                "$this save_now true" 10 0 left
        add_button $itk_component(ftfr) compile "Compile" \
                "$this compile_file" 10 0 right
        if {$BSPEC(BUILDPID) != ""} {
                $itk_component(compile) configure -state disabled
        }
}

itcl::body import_bvi_wizard::create_finish_window_bottom {} {
        add_frame $itk_component(ffr) fltf 0 0 left false
        add_frame $itk_component(ffr) frtf 0 0 left true
        add_scrolledtext $itk_component(fltf) fsnf "" none none
        pack $itk_component(fsnf)
        add_scrolledtext $itk_component(frtf) fstf ""
        pack $itk_component(fstf)
        $itk_component(fstf) import [get_bluespec_module_name].bsv
        set_finish_numbering
}

itcl::body import_bvi_wizard::add_status_component {f cname cval side} {
        itk_component add $cname {
                 label $f.$cname -textvariable $cval -bd 1
        } {
                keep -cursor -font
                rename -font -statusfont statusfont Font
                ignore -background
        }
        pack $itk_component($cname) -side $side -padx 20 -fill x
}

itcl::body import_bvi_wizard::add_frame {f name {x 0} {y 0} {side "top"} \
                                                        {exp "true"}} {
        itk_component add $name {
                frame $f.$name -takefocus 0
        }
        pack $itk_component($name) -fill both -expand $exp \
                        -padx $x -pady $y -side $side
}

itcl::body import_bvi_wizard::add_labeledframe {f name label {x 0} {y 0} \
                        {side "top"} {exp "true"} {pos "nw"} {relief flat}} {
        itk_component add $name {
                iwidgets::labeledframe $f.$name -labeltext $label \
                        -labelpos $pos -labelmargin 0 \
                        -relief $relief 
        }
        pack $itk_component($name) -fill both -expand $exp \
                        -padx $x -pady $y -side $side
}

itcl::body import_bvi_wizard::add_label {f name label {x 0} {y 0} \
                                        {side "top"} {exp "true"}} {
        itk_component add $name {
                label $f.$name -text $label
        }
        pack $itk_component($name) -fill both -expand $exp \
                        -padx $x -pady $y -side $side
}

itcl::body import_bvi_wizard::add_scrolledframe {f name label {side "top"} \
                        {x 0} {y 0} {exp "true"} \
                        {hscroll "dynamic"} {vscroll "dynamic"} {fill "both"}} {
        itk_component add $name {
                iwidgets::scrolledframe $f.$name -labeltext $label \
                        -labelpos nw -hscrollmode $hscroll -vscrollmode $vscroll
        }
        pack $itk_component($name) -fill $fill -expand $exp \
                        -padx $x -pady $y -side $side
}

itcl::body import_bvi_wizard::add_scrolledtext {f name label {hmode "static"} \
                                                {vmode "static"} {exp "true"}} {
        itk_component add $name {
                iwidgets::scrolledtext $f.$name \
                        -hscrollmode $hmode -vscrollmode $vmode \
                        -labeltext $label -labelpos nw -spacing3 1 -wrap none
        } {
                keep -textbackground
        }
        pack $itk_component($name) -fill both -expand $exp
        $itk_component($name) clear
}

itcl::body import_bvi_wizard::add_combobox {f name label {y 0} {x 0} \
                                {side "top"} {cmd ""} {fg "#696969"} {lp "w"}} {
        iwidgets::combobox $f.$name -labeltext $label -labelpos $lp \
                -listheight 120 -selectbackground #5598d7 \
                -selectforeground white -textbackground white -unique true \
                -foreground $fg -selectioncommand $cmd -command {}
        pack $f.$name -fill x -side $side -pady $y -padx $x
}

itcl::body import_bvi_wizard::add_entryfield {f name label {y 0} {x 0} \
                {side "top"} {exp "false"} {fg "#696969"} {cmd ""} {lp "w"}} {
        itk_component add $name {
                iwidgets::entryfield $f.$name -labeltext $label \
                        -textbackground white -labelpos $lp -foreground $fg \
                        -command $cmd
        } {
                keep -cursor -background
        }
        pack $itk_component($name) -fill x -pady $y -padx $x -side $side -expand $exp
}

itcl::body import_bvi_wizard::add_textentry {f name label {y 0} {height 0.5} \
                                                        {side "top"}} {
        itk_component add $name {
                iwidgets::scrolledtext $f.$name \
                        -hscrollmode dynamic -vscrollmode dynamic \
                        -labeltext $label -labelpos nw \
                        -selectbackground #6E9CFF \
                        -textbackground white -height $height
        } {
                keep -textbackground
        }
        pack $itk_component($name) -fill both -expand false -pady $y \
                -side $side -ipady 17
        $itk_component($name) clear
}

itcl::body import_bvi_wizard::add_button {f name text cmd width {y 0} \
                                              {side "top"} {state "normal"} {image ""} {expand {false}}} {
        global BSPEC
        itk_component add $name {
                button $f.$name -text $text -command $cmd -width $width \
                        -state $state
        }
        if {$image != ""} {
                $itk_component($name) configure -image [image create photo \
                        -file [file join $BSPEC(IMAGEDIR) $image]]
        }
        pack $itk_component($name) -fill x -pady $y -side $side -expand $expand
        set_bindings $name
}

itcl::body import_bvi_wizard::add_scrolledlistbox {f name label {cmd ""} \
                                        {width 150} {height 100} {side "top"}} {
        itk_component add $name {
                iwidgets::scrolledlistbox $f.$name -textbackground white \
                        -labelpos nw -labeltext $label -selectioncommand $cmd \
                        -width $width -height $height \
                        -hscrollmode dynamic -vscrollmode dynamic
        }
        pack $itk_component($name) -fill both -side $side -expand true -padx 5
}

itcl::body import_bvi_wizard::add_checkbox {f name label {side "top"}} {
        itk_component add $name {
                base::scrolledcheckbox $f.$name -labeltext $label \
                        -labelpos nw -canvbackground white
        }
        pack $itk_component($name) -side $side -expand true -fill both
}

itcl::body import_bvi_wizard::add_radiobox {f name {y 0} {side "top"} \
                {orient "horizontal"} {labelpos "w"} {text ""} {fg "black"}} {
        itk_component add $name {
                iwidgets::radiobox $f.$name \
                        -orient $orient -relief flat -labelmargin 0 \
                        -borderwidth 0 -labelpos $labelpos -labeltext $text \
                        -foreground $fg

        } {
                keep -cursor -background
        }
        pack $itk_component($name) -padx 15 -pady $y -fill both -side $side
}

itcl::body import_bvi_wizard::add_checkbutton {f name text cmd {side "top"} \
                                                                        {x 4}} {
        itk_component add $name {
                checkbutton $f.$name -text $text 
        } {
                keep -cursor -background
        }
        $itk_component($name) configure -command \
                "$cmd; $itk_component($name) select"
        pack $itk_component($name) -padx $x -pady 4 -fill both -side $side
}

itcl::body import_bvi_wizard::add_verilog_parameter_field {name {parent ""} \
                                                                {range ""}} {
        set id 0
        set f [$itk_component(param_fr) childsite] 
        while {[lsearch $verilog_parameter vp_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f vp_$name\_fr_$id
        set fr $itk_component(vp_$name\_fr_$id)
        add_entryfield $fr "vp_$name\_entv_$id" "" 2 0 left
        add_entryfield $fr "vp_$name\_entr_$id" "" 2 0 left
        add_button $fr "vp_$name\_add_bt_$id" \
               "" "$this add_verilog_parameter_field $name$id vp_$name\_fr_$id"\
               15 2 left normal add.gif
        add_button $fr "vp_$name\_del_bt_$id" "" "$this delete_field \
                verilog_parameter vp_$name\_fr_$id" 15 2 left normal delete.gif
        if {$parent != ""} {
                focus [$itk_component(vp_$name\_entv_$id) component entry]
                pack $fr -after $itk_component($parent)
                set verilog_parameter [linsert $verilog_parameter [expr \
                [lsearch $verilog_parameter $parent] +1] "vp_$name\_fr_$id"]
        } else {
                lappend verilog_parameter "vp_$name\_fr_$id"
                $itk_component(vp_$name\_entv_$id) insert 0 $name
                $itk_component(vp_$name\_entv_$id) configure -state disabled
                $itk_component(vp_$name\_entr_$id) insert 0 $range
                $itk_component(vp_$name\_entr_$id) configure -state disabled
        }
}

itcl::body import_bvi_wizard::add_verilog_input_field {name {parent ""}\
							{type ""} {range ""}} {
        set id 0
        set f [$itk_component(input_fr) childsite]
        while {[lsearch $verilog_input vi_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f vi_$name\_fr_$id
        set fr $itk_component(vi_$name\_fr_$id)
        add_entryfield $fr "vi_$name\_ent_$id" "" 2 0 left
        add_entryfield $fr "vi_$name\_rent_$id" "" 2 0 left
        add_radiobox $fr "vi_$name\_rb_$id" 0 left
        $itk_component(vi_$name\_rb_$id) add vi_clock -padx 15 -pady 0 \
                -highlightthickness 1
        $itk_component(vi_$name\_rb_$id) add vi_clock_gate -padx 29 -pady 0 \
                -highlightthickness 1
        $itk_component(vi_$name\_rb_$id) add vi_reset -padx 12 -pady 0 \
                -highlightthickness 1
        $itk_component(vi_$name\_rb_$id) add vi_none -padx 19 -pady 0 \
                -highlightthickness 1
        
        add_button $fr "vi_$name\_add_bt_$id" \
               "" "$this add_verilog_input_field $name$id vi_$name\_fr_$id" \
               15 2 left normal add.gif
        add_button $fr "vi_$name\_del_bt_$id" "" "$this delete_field \
                verilog_input vi_$name\_fr_$id" 15 2 left normal delete.gif
        set_add_verilog_input_field $id $name $type $range $parent
}

itcl::body import_bvi_wizard::add_verilog_output_field {name {parent ""} \
		      					{type ""} {range ""}} {
        set id 0
        set f [$itk_component(output_fr) childsite] 
        while {[lsearch $verilog_output vo_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f vo_$name\_fr_$id
        set fr $itk_component(vo_$name\_fr_$id)
        add_entryfield $fr "vo_$name\_ent_$id" "" 2 0 left
        add_entryfield $fr "vo_$name\_rent_$id" "" 2 0 left
        add_radiobox $fr "vo_$name\_rb_$id" 0 left
        $itk_component(vo_$name\_rb_$id) add vo_clock -padx 15 -pady 0 \
                -highlightthickness 1
        $itk_component(vo_$name\_rb_$id) add vo_clock_gate -padx 29 -pady 0 \
                -highlightthickness 1
        $itk_component(vo_$name\_rb_$id) add vo_reset -padx 12 -pady 0 \
                -highlightthickness 1
        $itk_component(vo_$name\_rb_$id) add vo_registered -padx 30 -pady 0 \
                -highlightthickness 1
        $itk_component(vo_$name\_rb_$id) add vo_none -padx 15 -pady 0 \
                -highlightthickness 1
        add_button $fr "vo_$name\_add_bt_$id" \
               "" "$this add_verilog_output_field $name$id vo_$name\_fr_$id" \
               15 2 left normal add.gif
        add_button $fr "vo_$name\_del_bt_$id" "" "$this delete_field \
                verilog_output vo_$name\_fr_$id" 15 2 left normal delete.gif
        set_add_verilog_output_field $id $name $type $range $parent
}

itcl::body import_bvi_wizard::add_verilog_inout_field {name {parent ""} \
                                                                {range ""}} {
        set id 0
        set f [$itk_component(inout_fr) childsite] 
        while {[lsearch $verilog_inout vio_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f vio_$name\_fr_$id
        set fr $itk_component(vio_$name\_fr_$id)
        add_entryfield $fr "vio_$name\_entv_$id" "" 2 0 left
        add_entryfield $fr "vio_$name\_entr_$id" "" 2 0 left
        add_button $fr "vio_$name\_add_bt_$id" \
               "" "$this add_verilog_inout_field $name$id vio_$name\_fr_$id"\
               15 2 left normal add.gif
        add_button $fr "vio_$name\_del_bt_$id" "" "$this delete_field \
                verilog_inout vio_$name\_fr_$id" 15 2 left normal delete.gif
        set_add_verilog_inout_field $id $name $range $parent
}

itcl::body import_bvi_wizard::add_bluespec_package_import_field \
                                                        {name {parent ""}} {
        set f [$itk_component(pckg_import_fr) childsite] 
        set id 0
        while {[lsearch $bluespec_package_import bpi_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f bpi_$name\_fr_$id
        set fr $itk_component(bpi_$name\_fr_$id)
        lappend bluespec_package_import "bpi_$name\_fr_$id"
        add_combobox $fr "bpi_$name\_cmb_$id" "" 2 0 left "" #0000ff
        pack $fr.bpi_$name\_cmb_$id -ipadx 68
        add_button $fr "bpi_$name\_add_bt_$id" \
               "" "$this add_bluespec_package_import_field $name$id $fr" \
               15 2 left normal add.gif
        add_button $fr "bpi_$name\_del_bt_$id" "" "$this delete_field \
                bluespec_package_import bpi_$name\_fr_$id" 15 2 \
                left normal delete.gif
        if {$parent != ""} {
                pack $fr -after $parent
        }
        set_bluespec_package_import_list bpi_$name\_fr_$id
}

itcl::body import_bvi_wizard::add_bluespec_provisos_field {name {parent ""}} {
        set f [$itk_component(provisos_fr) childsite] 
        set id 0
        while {[lsearch $bluespec_provisos bp_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f bp_$name\_fr_$id
        set fr $itk_component(bp_$name\_fr_$id)
        pack $fr -ipadx 79
        lappend bluespec_provisos "bp_$name\_fr_$id"
        add_entryfield $fr "bp_$name\_ent_$id" "" 2 0 left true #0000ff
        add_button $fr "bp_$name\_add_bt_$id" \
               "" "$this add_bluespec_provisos_field $name$id $fr" \
               15 2 left normal add.gif
        add_button $fr "bp_$name\_del_bt_$id" "" "$this delete_field \
                bluespec_provisos bp_$name\_fr_$id" 15 2 \
                left normal delete.gif
        if {$parent != ""} {
                pack $fr -after $parent
        }
        focus [$itk_component(bp_$name\_ent_$id) component entry]
}

itcl::body import_bvi_wizard::add_bluespec_module_args_field {name \
                                                                {parent ""}} {
        set f [$itk_component(module_args_fr) childsite] 
        set id 0
        while {[lsearch $bluespec_module_args bma_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f bma_$name\_fr_$id
        set fr $itk_component(bma_$name\_fr_$id)
        lappend bluespec_module_args "bma_$name\_fr_$id"
        add_entryfield $fr "bma_$name\_entt_$id" "" 2 0 left false #0000ff 
        add_entryfield $fr "bma_$name\_entn_$id" "" 2 0 left false #0000ff
        add_button $fr "bma_$name\_add_bt_$id" \
               "" "$this add_bluespec_module_args_field $name$id $fr" \
               15 2 left normal add.gif
        add_button $fr "bma_$name\_del_bt_$id" "" "$this delete_field \
                bluespec_module_args bma_$name\_fr_$id" 15 2 \
                left normal delete.gif
        if {$parent != ""} {
                pack $fr -after $parent
        }
        focus [$itk_component(bma_$name\_entt_$id) component entry]
}

itcl::body import_bvi_wizard::add_bluespec_parameter_binding {name} {
        set f [$itk_component(pbind_fr) childsite] 
        set id 0
        while {[lsearch $bluespec_parameter_binding bpb_$name\_fr_$id] != -1} {
                incr id
        }
        if {[lsearch $bluespec_parameter_binding_temp bpb_$name\_fr_$id] \
                                                                        != -1} {
                lappend bluespec_parameter_binding "bpb_$name\_fr_$id"
                set ind [lsearch $bluespec_parameter_binding_temp \
                        "bpb_$name\_fr_$id"]
                set bluespec_parameter_binding_temp [lreplace \
                        $bluespec_parameter_binding_temp $ind $ind]
                pack $itk_component(bpb_$name\_fr_$id) -fill both
                return
        } 
        add_frame $f bpb_$name\_fr_$id
        set fr $itk_component(bpb_$name\_fr_$id)
        lappend bluespec_parameter_binding "bpb_$name\_fr_$id"
        add_entryfield $fr "bpb_$name\_entvp_$id" "" 2 0 left
        add_entryfield $fr "bpb_$name\_entbe_$id" "" 2 0 left false #0000ff
        $itk_component(bpb_$name\_entvp_$id) insert 0 $name
        $itk_component(bpb_$name\_entvp_$id) configure -state disabled
}

itcl::body import_bvi_wizard::add_bluespec_input_clock_field {name \
                                                                {parent ""}} {
        set f [$itk_component(iclock_fr) childsite] 
        set id 0
        while {[lsearch $bluespec_input_clock bic_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f bic_$name\_fr_$id 0 10
        set fr $itk_component(bic_$name\_fr_$id)
        add_frame $fr bic_$name\_frl_$id 0 0 left
        add_frame $itk_component(bic_$name\_frl_$id) bic_$name\_frt_$id
        add_frame $itk_component(bic_$name\_frl_$id) bic_$name\_frb_$id
        add_frame $fr bic_$name\_frr_$id 0 0 left false 

        set frt $itk_component(bic_$name\_frt_$id)
        set frb $itk_component(bic_$name\_frb_$id)
        set frr $itk_component(bic_$name\_frr_$id)

        lappend bluespec_input_clock "bic_$name\_fr_$id"
        add_entryfield $frt "bic_$name\_ent_$id" "BSV clock" 2 0 left \
                false #0000ff "" n
        add_combobox $frt "bic_$name\_vccmb_$id" "Verilog clock" 0 0 left \
                "" "#696969" n
        add_combobox $frb "bic_$name\_vcgcmb_$id" "Verilog clock gate" 0 0 \
                left "" "#696969" n
        add_checkbutton $frr "bic_$name\_chb_$id" "Default" \
                "$this select_default_clock" top 0
        add_entryfield $frb "bic_$name\_eent_$id" "Expression" 2 0 left \
                false #0000ff "" n
        if {[llength $bluespec_input_clock] == 1} {
                $frr.bic_$name\_chb_$id select
                $itk_component(bic_$name\_eent_$id) insert 0 exposeCurrentClock
        }
        add_frame $frr bic_$name\_bf_$id 0 0 top
        set bfr $itk_component(bic_$name\_bf_$id)
        add_button $bfr "bic_$name\_del_bt_$id" "" "$this delete_field \
                bluespec_input_clock bic_$name\_fr_$id" 15 2 \
                right normal delete.gif
        add_button $bfr "bic_$name\_add_bt_$id" \
               "" "$this add_bluespec_input_clock_field $name$id $fr" \
               15 2 right normal add.gif
        set_bluespec_input_clock_field $fr $frt $name $id $parent
        set_cmb_bindings $frt.bic_$name\_vccmb_$id
        set_cmb_bindings $frb.bic_$name\_vcgcmb_$id
}

itcl::body import_bvi_wizard::add_bluespec_input_reset_field {name \
                                                {parent ""}} {
        set f [$itk_component(ireset_fr) childsite] 
        set id 0
        while {[lsearch $bluespec_input_reset bir_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f bir_$name\_fr_$id 0 10
        set fr $itk_component(bir_$name\_fr_$id)
        add_frame $fr bir_$name\_frl_$id 0 0 left
        add_frame $itk_component(bir_$name\_frl_$id) bir_$name\_frt_$id
        add_frame $itk_component(bir_$name\_frl_$id) bir_$name\_frb_$id
        add_frame $fr bir_$name\_frr_$id 0 0 left false 

        set frt $itk_component(bir_$name\_frt_$id)
        set frb $itk_component(bir_$name\_frb_$id)
        set frr $itk_component(bir_$name\_frr_$id)
        lappend bluespec_input_reset "bir_$name\_fr_$id"

        add_entryfield $frt "bir_$name\_ent_$id" "BSV reset" 2 0 left false #0000ff "" n
        add_combobox $frt "bir_$name\_vrcmb_$id" "Verilog reset" 2 0 left "" "#696969" n
        add_combobox $frb "bir_$name\_bccmb_$id" "Bluespec clock" 2 0 left "" #0000ff n
        add_checkbutton $frr "bir_$name\_chb_$id" "Default" \
                "$this select_default_reset" top 0
        add_entryfield $frb "bir_$name\_eent_$id" "Expression" 2 0 left false #0000ff "" n
        if {[llength $bluespec_input_reset] == 1} {
                $frr.bir_$name\_chb_$id select
                $itk_component(bir_$name\_eent_$id) insert 0 exposeCurrentReset
        }
        add_frame $frr bir_$name\_bf_$id 0 0 top
        set bfr $itk_component(bir_$name\_bf_$id)
        add_button $bfr "bir_$name\_del_bt_$id" "" "$this delete_field \
                bluespec_input_reset bir_$name\_fr_$id" 15 2 \
                right normal delete.gif
        add_button $bfr "bir_$name\_add_bt_$id" \
               "" "$this add_bluespec_input_reset_field $name$id $fr" \
               15 2 right normal add.gif
        set_bluespec_input_reset_field $fr $frt $name $id $parent
        set_cmb_bindings $frt.bir_$name\_vrcmb_$id
}

itcl::body import_bvi_wizard::add_bluespec_inout_field {name {parent ""}} {
        set f [$itk_component(binout_fr) childsite] 
        set id 0
        while {[lsearch $bluespec_inout bi_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f bi_$name\_fr_$id
        set fr $itk_component(bi_$name\_fr_$id)
        lappend bluespec_inout "bi_$name\_fr_$id"
        add_combobox $fr "bi_$name\_ivpcmb_$id" "" 2 0 left
        add_combobox $fr "bi_$name\_ibccmb_$id" "" 2 0 left "" #0000ff
        add_combobox $fr "bi_$name\_ibrcmb_$id" "" 2 0 left "" #0000ff
        add_entryfield $fr "bi_$name\_ieent_$id" "" 2 0 left false #0000ff

        add_button $fr "bi_$name\_add_bt_$id" \
               "" "$this add_bluespec_inout_field $name$id $fr" \
               15 2 left normal add.gif
        add_button $fr "bi_$name\_del_bt_$id" "" "$this delete_field \
                bluespec_inout bi_$name\_fr_$id" 15 2 left normal delete.gif
        set_bluespec_inout_field $name $id $parent
}

itcl::body import_bvi_wizard::add_method_binding_args_field \
                                                {f name {parent ""} {text ""}} {
        set id 0
	set t [join [split $f "."] "_"]
        while {[lsearch $METHOD_BINDING_ARGS($f) mpb_$t\_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f mpb_$t\_$name\_fr_$id
        set fr $itk_component(mpb_$t\_$name\_fr_$id)
        set pp [lsearch $METHOD_BINDING_ARGS($f) $parent]
        incr pp
        set METHOD_BINDING_ARGS($f) [linsert $METHOD_BINDING_ARGS($f) $pp \
                "mpb_$t\_$name\_fr_$id"]
        add_entryfield $fr "mpb_$t\_$name\_ent_$id" "" 2 0 left false #0000ff
        add_combobox $fr "mpb_$t\_$name\_vncmb_$id" "" 0 0 left 
        foreach i [get_verilog_input] {
                if {[lindex $i 2] != "clock" && [lindex $i 2] != "reset"} {
                        if {[lindex $i 1] == "0 : 0"} {
                                set n [lindex $i 0]
                        } else {
                                set n [format "%s /* %s */" [lindex $i 0] \
                                        [lindex $i 1]]
                        }
                        $fr.mpb_$t\_$name\_vncmb_$id insert list end $n
                }
        }
        add_button $fr "mpb_$t\_$name\_add_bt_$id" \
               "" "$this add_method_binding_args_field $f $name$id \
               mpb_$t\_$name\_fr_$id" 15 2 left normal add.gif
        add_button $fr "mpb_$t\_$name\_del_bt_$id" "" "$this delete_field \
                METHOD_BINDING_ARGS($f) mpb_$t\_$name\_fr_$id" 15 2 \
                left normal delete.gif
        if {$parent != ""} {
                pack $fr -after $itk_component($parent)
        }
        set list [get_verilog_input]
        if {[lsearch -index 0 $list $name] != -1} {
                $fr.mpb_$t\_$name\_vncmb_$id insert entry end $name
                set fields [lsearch -inline -index 0 $list $name]
                set range [create_bsv_type [lindex $fields 1]]
                $itk_component(mpb_$t\_$name\_ent_$id) insert end $range
        } else {
                $itk_component(mpb_$t\_$name\_ent_$id) insert end $text
        }
}

itcl::body import_bvi_wizard::add_port_binding_field {f name {parent ""} ind} {
        set id 0
        while {[lsearch $port_binding $ind\_pb_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f $ind\_pb_$name\_fr_$id
        set fr $itk_component($ind\_pb_$name\_fr_$id)
        lappend port_binding "$ind\_pb_$name\_fr_$id"
        add_combobox $fr "$ind\_pb_$name\_pbvcmb_$id" "" 0 0 left 
        add_combobox $fr "$ind\_pb_$name\_pbecmb_$id" "" 0 0 left 
        foreach i [get_bluespec_parameter_binding] {
                $fr.$ind\_pb_$name\_pbecmb_$id insert list end [lindex $i 1]
        }
        add_button $fr "pb_$name\_add_bt_$id" \
               "" "$this add_port_binding_field $f $name$id $fr $ind" \
               15 2 left normal add.gif
        add_button $fr "pb_$name\_del_bt_$id" "" "$this delete_field \
                port_binding $ind\_pb_$name\_fr_$id" 15 2 \
                left normal delete.gif
        if {$parent != ""} {
                pack $fr -after $parent
        } else {
                $fr.$ind\_pb_$name\_pbvcmb_$id insert entry 0 $name
                $fr.$ind\_pb_$name\_pbvcmb_$id configure -editable readonly
        }
        foreach i [get_verilog_input] {
                if {[lindex $i 2] != "clock" && [lindex $i 2] != "reset" \
                        && [lindex $i 1] != "0 : 0"} {
                        set n [format "%s /* %s */" [lindex $i 0] [lindex $i 1]]
                        $fr.$ind\_pb_$name\_pbvcmb_$id insert list end $n
                }
        }
        focus [$fr.$ind\_pb_$name\_pbvcmb_$id component entry]
}

itcl::body import_bvi_wizard::add_combinational_path_field {f name \
                                                                {parent ""}} {
        set id 0
        while {[lsearch $combinational_path cp_$name\_fr_$id] != -1} {
                incr id
        }
        add_frame $f cp_$name\_fr_$id 0 0 top false
        set fr $itk_component(cp_$name\_fr_$id)
        lappend combinational_path "cp_$name\_fr_$id"
        add_scrolledframe $fr "cp_$name\_input_scfr_$id" "" left 0 0 true none
        set csi [$itk_component(cp_$name\_input_scfr_$id) childsite]
        add_frame $csi cpi_$name\_add_bt_fr_$id 0 0 top false
        pack $itk_component(cpi_$name\_add_bt_fr_$id) -ipadx 70
        add_label $itk_component(cpi_$name\_add_bt_fr_$id) \
                cpi_$name\_lfr_$id "Input   " 0 0 left
        add_button $itk_component(cpi_$name\_add_bt_fr_$id) \
                "cpi_$name\_add_bt_$id" "Add +" \
                "$this add_combinational_path_input_field $csi ci_path \
                $itk_component(cpi_$name\_add_bt_fr_$id)" 3 1 top
        add_scrolledframe $fr "cp_$name\_output_scfr_$id" "" left 0 0 true none
        set cso [$itk_component(cp_$name\_output_scfr_$id) childsite]
        add_frame $cso cpo_$name\_add_bt_fr_$id 0 0 top false
        pack $itk_component(cpo_$name\_add_bt_fr_$id) -ipadx 63
        add_label $itk_component(cpo_$name\_add_bt_fr_$id) \
                cpo_$name\_lfr_$id "Output   " 0 0 left
        add_button $itk_component(cpo_$name\_add_bt_fr_$id) \
                "cpo_$name\_add_bt_$id" "Add +" \
                "$this add_combinational_path_output_field $cso co_path \
                $itk_component(cpo_$name\_add_bt_fr_$id)" 3 1 top 
        add_frame $fr cp_$name\_bt_fr_$id 0 10 left false
        add_button $itk_component(cp_$name\_bt_fr_$id) "cp_$name\_add_bt_$id" \
               "" "$this add_combinational_path_field $f $name$id $fr" \
               15 2 top normal add.gif
        add_button $itk_component(cp_$name\_bt_fr_$id) "cp_$name\_del_bt_$id" \
                "" "$this delete_field combinational_path cp_$name\_fr_$id \
		path" 15 2 top normal delete.gif
        if {$parent != ""} {
                pack $fr -after $parent
        }
        add_combinational_path_input_field $csi ci_path \
                $itk_component(cpi_$name\_add_bt_fr_$id)
        add_combinational_path_output_field $cso co_path \
                $itk_component(cpo_$name\_add_bt_fr_$id)
}

itcl::body import_bvi_wizard::add_combinational_path_input_field {f name \
                                                                {parent ""}} {
        set id 0
	foreach l $combinational_path_input {
		while {[lsearch -start 1 $l cpi_$name\_fr_$id] != -1} {
			incr id
		}
	}
        add_frame $f cpi_$name\_fr_$id
        set fr $itk_component(cpi_$name\_fr_$id)
	set ind [lsearch -index 0 $combinational_path_input $f]
	if {$ind != -1} {
		set combinational_path_input [lreplace \
		$combinational_path_input $ind $ind "[lindex \
		$combinational_path_input $ind] cpi_$name\_fr_$id"]
	} else {
		lappend combinational_path_input "$f cpi_$name\_fr_$id"
	}
        add_combobox $fr "cpi_$name\_cmb_$id" "" 0 0 left
	set cmb $fr\.cpi_$name\_cmb_$id
        focus [$cmb component entry]
	$cmb clear
	foreach v [get_verilog_input] {
		$cmb insert list end [lindex $v 0]
	}
        add_button $fr "cpi_$name\_add_bt_$id" \
               "" "$this add_combinational_path_input_field $f $name$id $fr" \
               15 2 left normal add.gif
        add_button $fr "cpi_$name\_del_bt_$id" "" "$this delete_field \
                combinational_path_input cpi_$name\_fr_$id paths" 15 2 \
                left normal delete.gif
        if {$parent != ""} {
                pack $fr -after $parent
        }
        $cmb configure -editable readonly
}

itcl::body import_bvi_wizard::add_combinational_path_output_field {f name \
                                                                {parent ""}} {
        set id 0
	foreach l $combinational_path_output {
	        while {[lsearch -start 1 $l cpo_$name\_fr_$id] != -1} {
                	incr id
		}
	}
        add_frame $f cpo_$name\_fr_$id
        set fr $itk_component(cpo_$name\_fr_$id)
	set ind [lsearch -index 0 $combinational_path_output $f]
	if {$ind != -1} {
		set combinational_path_output [lreplace \
		$combinational_path_output $ind $ind "[lindex \
		$combinational_path_output $ind] cpo_$name\_fr_$id"]
	} else {
		lappend combinational_path_output "$f cpo_$name\_fr_$id"
	}

        add_combobox $fr "cpo_$name\_cmb_$id" "" 0 0 left
	set cmb $fr\.cpo_$name\_cmb_$id
        focus [$cmb component entry]
	$cmb clear
	foreach v [get_verilog_output] {
		$cmb insert list end [lindex $v 0]
	}
        add_button $fr "cpo_$name\_add_bt_$id" \
               "" "$this add_combinational_path_output_field $f $name$id $fr" \
               15 2 left normal add.gif
        set s [lsearch $combinational_path_output cpo_$name\_fr_$id]
        add_button $fr "cpo_$name\_del_bt_$id" "" "$this delete_field \
                combinational_path_output cpo_$name\_fr_$id paths" 15 2 \
                left normal delete.gif
        if {$parent != ""} {
                pack $fr -after $parent
        }
        $cmb configure -editable readonly
}

itcl::body import_bvi_wizard::remove_subinterface_from_list {name} {
        set parent ""
        foreach i $interface_binding {
                set id [lsearch $interface_binding $i]  
                if {[set ind [lsearch $i $name]] != -1} {
                        if {$ind >= 2} {
                                set interface_binding [lreplace \
                                        $interface_binding $id $id \
                                        [lreplace $i $ind $ind]]
                                break
                        }
                }
        }
        if {[info exists itk_component($name)]} {
                destroy $itk_component($name)
        }
        set id [lsearch -index 0 $interface_binding $name]
        set parent [lindex [lindex $interface_binding $id] 1]
        set interface_binding [lreplace $interface_binding $id $id]
        if {$parent != "no_parent"} {
                set_method_port_interface_size $parent "interface" "-" "" 
        } else {
                set_method_port_interface_size "" "interface" "-" \
                        $itk_component(mpi_propagate_0)
        }
        set id [lsearch -index 0 $propagate_list [regsub "_fr_" $name \
                "_propagate_"]]
        set propagate_list [lreplace $propagate_list $id $id]
}

itcl::body import_bvi_wizard::remove_method_from_list {name} {
        set parent ""
        foreach i $interface_binding {
                set id [lsearch $interface_binding $i]  
                if {[set ind [lsearch $i $name]] != -1} {
                        set interface_binding [lreplace $interface_binding \
                                $id $id [lreplace $i $ind $ind]]
                        set parent [lindex [lindex $interface_binding $id] 0]
                }
        }
        if {[info exists itk_component($name)]} {
                destroy $itk_component($name)
        }
        set id [lsearch -index 0 $method_bindings $name]
        set method_bindings [lreplace $method_bindings $id $id]
        if {$parent != ""} {
                set_method_port_interface_size $parent "method" "-" "" 
        } else {
                set_method_port_interface_size "" "method" "-" \
                        $itk_component(mpi_propagate_0)
        }
}

itcl::body import_bvi_wizard::delete_field {variable name {type ""}} {
	if {$type == "path"} {
		set id [lsearch -index 0 $combinational_path_input \
			[$itk_component([regsub "_fr_" $name "_input_scfr_"]) \
			childsite]]
		set combinational_path_input [lreplace \
			$combinational_path_input $id $id]
		set id [lsearch -index 0 $combinational_path_output \
			[$itk_component([regsub "_fr_" $name "_output_scfr_"]) \
			childsite]]
		set combinational_path_output [lreplace \
			$combinational_path_output $id $id]
	} elseif {$type == "paths"} {
		for {set i 0} {$i < [eval llength $$variable]} {incr i} {
			set id [lsearch [eval lindex $$variable $i] $name]
			if {$id != -1} {
				set $variable [eval lreplace $$variable $i \
					$i [list [lreplace [eval lindex \
					$$variable $i] $id $id]]]
				destroy $itk_component($name)
				return
			}
		}
	} elseif {$type == "port"} {
                set ind [lindex [split $name _] end]
                foreach p $port_binding {
                        if {$ind == [lindex [split $p _] 0]} {
                                set id [lsearch $port_binding $p]
                                set port_binding [lreplace $port_binding \
                                        $id $id]
                        }
                }
        }
        destroy $itk_component($name)
        set id [eval lsearch -index 0 $$variable $name]
        set $variable [eval lreplace $$variable $id $id]
}

## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
