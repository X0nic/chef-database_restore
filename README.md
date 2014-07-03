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
    <td><tt>['database_restore']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
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
