
# Opens the specified project
handlers::open_project project.bspec

# Displays the project status
commands::display_project_status

# Opens/maximizes the 'Project Files' window
handlers::show -project

# Opens/maximizes the 'Package' window
handlers::show -package

# Opens/maximizes the 'Module Browser' window
handlers::show -module_browser

# Opens/maximizes the 'Type Browser' window
handlers::show -type_browser

# Opens/maximizes the 'Schedule Analysis' window
handlers::show -schedule_analysis

# Minimizes all currently open windows except the main window
commands::minimize_all

# Closes all currently open windows except the main window
commands::close_all

# Closes the project
handlers::close_project

# Exits the workstation
exit

