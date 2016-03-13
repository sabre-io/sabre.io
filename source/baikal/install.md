---
product: baikal 
title: Installation
layout: default
---

Requirements
------------

Baikal requires:

* PHP 5.5
* MySQL or SQLite
* Apache or Nginx

Installation instructions
-------------------------

To install Baïkal, download the latest zip file from the [releases page on github][1].
After downloading the file, unpack it and upload it to your server.

After uploading, you _must_ make sure that the `Specific` directory is writeable by
your webserver process. This might mean that you need to give 'world-write' access
via your FTP client, or maybe that you run `chown www-data:www-data Specific` on
a console.

After that step has been completed, you can access the installer by browsing to

    http://yourserver.example.org/baikal/html/

Follow the intructions there to complete the installation.

Securing your installation
--------------------------

Only the `html` directory is needed to be accessible by your web browser. You
may choose to lock out access to any other directory using your webserver
configuration.

In particular you should really make sure that the `Specific` directory is not
accessible directly, as this could contain your sql database.

Apache vhost installation
-------------------------

The following configuration file may be used as a standard template to configure
an apache vhost as a dedicated Baïkal vhost:

```apache
<VirtualHost *:80>

    DocumentRoot /var/www/baikal/html
    ServerName dav.example.org

    RewriteEngine On
    RewriteRule /.well-known/carddav /dav.php [R,L]
    RewriteRule /.well-known/caldav /dav.php [R,L]

    <Directory "/var/www/baikal/html">
        Options None
        Options +FollowSymlinks
        AllowOverride All

        # Confiugration for apache-2.2:
        Order allow,deny
        Allow from all

        # Confiugration for apache-2.4:
        Require all granted
    </Directory>

</VirtualHost>
```


Nginx configuration
-------------------

The following configuration may be used for nginx:


```nginx
server {
  listen       80;
  server_name  dav.example.org;

  root  /var/www/baikal/html;
  index index.php;

  rewrite ^/.well-known/caldav /dav.php redirect;
  rewrite ^/.well-known/carddav /dav.php redirect;
  
  charset utf-8;

  location ~ /(\.ht|Core|Specific) {
    deny all;
    return 404;
  }

  location ~ ^(.+\.php)(.*)$ {
    try_files $fastcgi_script_name =404;
    fastcgi_split_path_info  ^(.+\.php)(.*)$;
    fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    fastcgi_param  PATH_INFO        $fastcgi_path_info;
    include        /etc/nginx/fastcgi_params;
  }
}
```


[1]: https://github.com/fruux/Baikal/releases
