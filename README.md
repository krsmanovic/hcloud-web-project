# Infrastructure code for my personal web project

Terraform state file and state lock table are hosted in AWS, while servers are hosted in Hetzner Cloud.

Server list:

- bastion
- nextcloud
- web (planned)

## Nextcloud tuning

### php

- The problem

> WARNING: [pool www] server reached pm.max_children setting (5), consider raising it

- Solution

```bash
sed -i 's/pm = dynamic/pm = static/' /etc/php/8.1/fpm/pool.d/www.conf
sed -i 's/pm.max_children = 5/pm.max_children = 50/' /etc/php/8.1/fpm/pool.d/www.conf
```

Source: [server reached pm.max_children setting (5)](https://webmasters.stackexchange.com/questions/119986/server-reached-pm-max-children-setting-5)

- Validation: sum php-fpm memory used (in MB):

```bash
ps -eo size,pid,user,command --sort -size | awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' | grep php-fpm | grep www | awk '{sum+=$1;} END{print sum;}'
```
