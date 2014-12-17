# picdump. 

Processes images sent to a mailgun adress and and stores them on S3, hey! - it can show the pictures too! :)

The application is divided into 2 different roles, SOA style to allow for easy scaling by adding HAProxy or equivalent infront and distributing the load among the nodes.

1. web/api 
1. workers 

The application uses redis for it's main database, ofc. redis should be setup in a redundant manner.

Configuration is in ./config.rb, either change the required API keys there or inject them in production mode using environment variables (recommended!)

# Web
the web app can be hosted with for instance varnish->nginx->unicorn, to allow for nginx to host the static files.
the web app uses no haml/erb generated files, and is served as a SPA (Single Page Application) using angularjs as MVVM layer.

## To install (on OSX)
```bash
$ brew install bower
$ bower install
$ bundle install
```
## To run (in development mode)
```bash
$ rackup -p 4567
```

# Worker
the app use sidekiq for parallell processing on SMP capable system (using Celluloid) 
## To install (on osx)
```bash
$ bundle install
```

## To run (in development mode)
```bash
$ bundle exec 'sidekiq -r ./workers/image_worker.rb'
```
# Mailgun
Set a catch_all() route to post to /api/v1/mailnotify

e.g.
```
store(notify="http://somehost.com:80/api/v1/mailnotify")
```
