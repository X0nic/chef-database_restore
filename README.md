# database_restore-cookbook

[![Build Status](https://travis-ci.org/X0nic/chef-database_restore.svg?branch=master)](https://travis-ci.org/X0nic/chef-database_restore)

Cookbook to restore a mysql database backup generated from [Backup](https://github.com/meskyanichi/backup)

## Supported Platforms

* Ubuntu 12.04

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['database_restore']['s3_bucket']</tt></td>
    <td>String</td>
    <td>s3 bucket to grab from</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['database_restore']['s3_dir_path']</tt></td>
    <td>String</td>
    <td>path inside the s3 bucket to the date directories</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['database_restore']['database_name']</tt></td>
    <td>String</td>
    <td>database to restore to</td>
    <td><tt>wordpress</tt></td>
  </tr>
  <tr>
    <td><tt>['database_restore']['database_user']</tt></td>
    <td>String</td>
    <td>database user used to restore</td>
    <td><tt>wordpress</tt></td>
  </tr>
  <tr>
    <td><tt>['database_restore']['database_backup_name']</tt></td>
    <td>String</td>
    <td>name of database found inside the backup</td>
    <td><tt>node[:database_restore][:database_name]</tt></td>
  </tr>
</table>

## Usage

### database_restore::default

Include `database_restore` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[database_restore::default]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Nathan Lee (<nathan@globalphobia.com>)
