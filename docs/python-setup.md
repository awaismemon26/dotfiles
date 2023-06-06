# Pip SSL issues on Corporate Network M1-MAC

![pip-ssl-issue](/docs/images/pip.png)

To resolve this issue, create a file in the following location *```$HOME/Library/Application Support/pip/pip.conf```*

```conf
[global]
trusted-host = pypi.python.org
               pypi.org
               files.pythonhosted.org
```
