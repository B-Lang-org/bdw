
# Starts the waveform viewer
handlers::start_waveform_viewer

# Attaches the selected waveform viewer
handlers::attach_waveform_viewer Novas

# Loads the dump file
handlers::load_dump_file file

# Reloads the dump file
handlers::reload_dump_file

# Opens the specified project
handlers::open_project project.bspec 

# Specifies Non-Bsv hierarchy for the waveform viewer
#handlers::set_nonbsv_hierarchy /main/top

# Specifies options for waveform viewer
#handlers::set_waveform_viewer Novas -command nWave -options -nologo -close 1

# Attaches the selected waveform viewer
handlers::attach_waveform_viewer

# Starts the waveform viewer
handlers::start_waveform_viewer

# Loads the dump file
handlers::load_dump_file file

# Reloads the dump file
handlers::reload_dump_file

# Attaches the selected waveform viewer
handlers::attach_waveform_viewer wrong

# Starts the waveform viewer
handlers::start_waveform_viewer

# Attaches the selected waveform viewer
handlers::attach_waveform_viewer nWave

# Reloads the dump file
handlers::reload_dump_file

# Loads the dump file
handlers::load_dump_file

# Loads the dump file
handlers::load_dump_file wrong

# Loads the dump file
handlers::load_dump_file ./waveform_viewer_options_test.tcl

# Reloads the dump file
handlers::reload_dump_file

# Closes the current project
handlers::close_project

# Exits the workstation
exit
