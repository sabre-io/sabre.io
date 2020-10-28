---
product: baikal 
title: Installation
layout: default
---

Requirements
------------

Baikal requires:

* PHP 7
* MySQL or SQLite
* Apache or Nginx

Installation instructions
-------------------------

To install Baïkal, download the latest zip file from the [releases page on github][1].
After downloading the file, unpack it and upload it to your server.

After uploading, you _must_ make sure that the `Specific` and the `config` directories
are writeable by your webserver process. This might mean that you need to give
'world-write' access via your FTP client, or maybe that you run 
`chown -R www-data:www-data Specific config` on a console.

After that step has been completed, you can access the installer by browsing to

    http://yourserver.example.org/baikal/html/

Follow the intructions there to complete the installation.

<img src='/img/baikal-admin-wizard.png' style="width: 100%; max-width: 640px;" />

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
<VirtualHost *:443>

    DocumentRoot /var/www/baikal/html
    ServerName dav.example.org

    RewriteEngine on
    # Generally already set by global Apache configuration
    # RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
    RewriteRule /.well-known/carddav /dav.php [R=308,L]
    RewriteRule /.well-known/caldav  /dav.php [R=308,L]

    <Directory "/var/www/baikal/html">
        Options None
        # If you install cloning git repository, you may need the following
        # Options +FollowSymlinks
        AllowOverride None
        # Configuration for apache-2.4:
        Require all granted
        # Configuration for apache-2.2:
        # Order allow,deny
        # Allow from all
    </Directory>

    <IfModule mod_expires.c>
        ExpiresActive Off
    </IfModule>

    SSLEngine on
    SSLCertificateFile    /etc/letsencrypt/live/dav.example.org/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/dav.example.org/privkey.pem

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
    include        /etc/nginx/fastcgi_params;
    fastcgi_split_path_info  ^(.+\.php)(.*)$;
    fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    fastcgi_param  PATH_INFO        $fastcgi_path_info;
  }
}
```


[1]: https://github.com/sabre-io/Baikal/releases
