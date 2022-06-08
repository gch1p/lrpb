
# lrpb 

Means "last resort primitive backdoor".

For when you can't log in via ssh but something's still alive...


## Requirements

- bash 4+
- GNU tar
- curl or wget
- signify from openbsd
- rsync
- ssh


## Installation

	make install


## Client side usage

First, create a pair of keys:

	signify -G -p myname.pub -s myname.sec

Then write a script you want to be launched on remote side:

	#!/bin/sh
	touch ~/helloworld-it-works

Write lrpb client config to `client.conf`:

	# ssh config
	upload_host=mydomain.org
	upload_port=22
	upload_user=user
	upload_path=/home/user/www/lrpb

	name=myname

	signify_path=/bin/signify
	seckey_path=./myname.sec

Finally, sign and upload it to some remote server you control:

	lrpb upload -c ./client.conf -f ./script.sh

On remote server, set up some http server (nginx, lighttpd, apache, whatever) that serves directory you upload to.
The script will upload archive name `myname.tar.gz` and it must be accessible by http.


## Server side usage

Copy public key to `/etc/lrpb.pub` on the server (or anywhere you
want, just make sure to set correct path in the config).

Write lrpb server config and save it to `/etc/lrpb.conf`:

	url="https://mydomain.org/lrpb/"
	pubkey_path=/etc/lrpb.pub
	name=myname
	signify_path=/usr/bin/signify-openbsd
	cwd=/var/lrpbfsq
	cache_file=/var/lrpbfs/cache

> Optionally, make `/var/lrpbfs` a tmpfs mountpoint. Add to `/etc/fstab`:
> 
>  ```
>  tmpfs /var/lrpbfs tmpfs size=1M,mode=1755,uid=1000,gid=1000 0 0
>  ```
> 
> Then mount it:
> ```
> mount /var/lrpbfs
> ```

Test that it works:

	lrpb exec

Add cron task (`crontab -e`):

	0,30 * * * * /usr/local/bin/lrpb exec >/dev/null


## License

BSD-2c

