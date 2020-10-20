
# Opens the specified project
handlers::open_project project.bspec

# Displays the project status
commands::display_project_status

# Backup the project
handlers::backup_project project.tgz -input_files

# Backup the project
handlers::backup_project project.tgz -project_dir

# Backup the project
handlers::backup_project project.tgz -search_path

# Backup the project
handlers::backup_project project.tgz -input_files -project_dir

# Backup the project
handlers::backup_project project.tgz -input_files -search_path

# Backup the project
handlers::backup_project project.tgz -project_dir -search_path

# Backup the project
handlers::backup_project project.tgz -input_files -project_dir -search_path

# Backup the project
handlers::backup_project project.tgz -input_files -options -zv

## Backup the project
#handlers::backup_project project.tgz -project_dir -options -zv
#
## Backup the project
#handlers::backup_project project.tgz -search_path -options -zv
#
## Backup the project
#handlers::backup_project project.tgz -input_files -project_dir -options -zv
#
## Backup the project
#handlers::backup_project project.tgz -input_files -search_path -options -zv
#
## Backup the project
#handlers::backup_project project.tgz -project_dir -search_path -options -zv
#
## Backup the project
#handlers::backup_project project.tgz -input_files -project_dir -search_path -options -zv
#
## Backup the project
#handlers::backup_project project.tgz -input_files -project_dir -search_path -options -zv -search_path_files .bo

# Closes the project
handlers::close_project

# Exits the workstation
exit
