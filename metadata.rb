name             'database_restore'
maintainer       'Nathan Lee'
maintainer_email 'nathan@globalphobia.com'
license          'All rights reserved'
description      'Installs/Configures database_restore'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue "0.1.0"

depends 'mysql'
depends 's3_file'
