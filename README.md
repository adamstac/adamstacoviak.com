# Self

The source code for [adamstacoviak.com](http://adamstacoviak.com/)

## TODO

- Update the date styles on a post's show page
- Add tag support
- Fix images
- Add a link to the feed URL

## nginx Configuration

The following is the nginx configuration being used for this site.

    server {
      server_name adamstacoviak.com;
      listen 80;
      root /var/www/adamstacoviak.com/html;
      index index.html;

      # Redirect /foo/ and /foo/index.html to /foo
      rewrite ^(.+)/+$ $1 permanent;
      rewrite ^(.+)/index.html$ $1 permanent;

      # Redirect foo.html to foo
      rewrite ^(/.+)\.html$ $1 permanent;

      location / {
        default_type "text/html";
        try_files $uri.html $uri $uri/index.html =404;
      }

      location = /feed {
        return 301 /feed.xml;
      }

      error_page 404 /404.html;
      error_page 500 502 503 504 /50x.html;
    }
