default[:database_restore][:s3_bucket]   = ''
default[:database_restore][:s3_dir_path] = ''
default[:database_restore][:database_name] = 'wordpress'
default[:database_restore][:database_user] = 'wordpress'
default[:database_restore][:database_backup_name] = node[:database_restore][:database_name]
