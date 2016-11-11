<!--[![Build status](https://ci.appveyor.com/api/projects/status/aovgv1lycoj6ius8/branch/master?svg=true)](https://ci.appveyor.com/project/gerane/vscodeextensions/branch/master)-->
[![Documentation Status](https://readthedocs.org/projects/poshzabbixtools/badge/?version=latest)](http://poshzabbixtools.readthedocs.io/en/latest/?badge=latest)

# PoshZabbixTools Module

This module lets you manage your Zabbix monitoring environment.

## Installation

Install from PSGallery. (Soon)

```powershell
PS> Install-Module -Name PoshZabbixTools
```

## Getting Started

Connect to the Zabbix server using the Connect-ZabbixServer command

```powershell
PS> Connect-ZabbixServer -Server 'ServerName' -Secure -Credential (Get-Credential)
```

Get a list of available commands

```powershell
PS> Get-Command -Module PoshZabbixTools
```

## Documentation

* Full documentation is available in [ReadTheDocs](http://poshzabbixtools.readthedocs.io/en/latest/) format.

## Links

- Github - [Trent Willingham](https://github.com/twillin912)


## License

[MIT](LICENSE)


## Notes

* [Simon Morand](https://github.com/simnyc) started this idea with his [zabbixPoshAPI](https://github.com/simnyc/zabbixPoshAPI).


