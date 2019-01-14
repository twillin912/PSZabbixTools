# ZabbixTools PowerShell Module

[![Build status](https://ci.appveyor.com/api/projects/status/github/twillin912/pszabbixtools?branch=stable&passingText=stable%20-%20OK&svg=true)](https://ci.appveyor.com/project/twillin912/pszabbixtools/branch/stable)
[![Documentation Status](http://readthedocs.org/projects/pszabbixtools/badge/?version=latest)](http://pszabbixtools.readthedocs.io/en/latest/?badge=latest)

Zabbix tools.

## Installation

Install from PSGallery

```powershell
PS> Install-Module -Name ZabbixTools
```

## Getting Started

Connect to the Zabbix server using the Connect-ZabbixServer command

```powershell
PS> Connect-ZabbixServer -Server 'ServerName' -Secure -Credential (Get-Credential)
```

Get a list of available commands

```powershell
PS> Get-Command -Module ZabbixTools
```

## Documentation

* Full documentation is available in [ReadTheDocs](http://pszabbixtools.readthedocs.io/en/latest/) format.

## Links

- Github - [Trent Willingham](https://github.com/twillin912)


## License

[BSD-3](LICENSE)


## Notes

Thanks go to:
* [Simon Morand](https://github.com/simnyc) started this idea with his [zabbixPoshAPI](https://github.com/simnyc/zabbixPoshAPI).

