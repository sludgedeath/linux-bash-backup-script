# linux-bash-backup-script

**Incremental and rotating linux bash backup script**

Incremental and rotating linux bash backup script which keeps original folder structure and does not overwrite unchanged files. Supports multiple backup destinations and filenames containing whitespaces and non-alphanumeric characters. Uses no compression.
Setup:

* edit `DAYS`, `TARGET` and `SOURCE` in bash.sh

* edit `crontab parameters` in install.sh

* `chmod +x install.sh && ./install.sh`

Check out the website:
https://sludgedeath.github.io/linux-bash-backup-script/
