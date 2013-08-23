
## Initial setup

Copy `_couchmusic.json.example` to `~/.couchmusic.json`, and edit it to point
to your CouchDB database.

Run the following command to set the CouchDB username and password that
couchmusic will use to connect to the database:

    (read -p User: USER; read -sp Password: PASS; echo; security add-generic-password -s couchmusic -a $USER -p $PASS -U)


## Generated CouchApp

This is meant to be an example CouchApp and to ship with most of the CouchApp goodies.

Clone with git:

    git clone git://github.com/couchapp/example.git
    cd example

Install with 
    
    couchapp push . http://localhost:5984/example

or (if you have security turned on)

    couchapp push . http://adminname:adminpass@localhost:5984/example
  
You can also create this app by running

    couchapp generate example && cd example
    couchapp push . http://localhost:5984/example

Deprecated: *couchapp generate proto && cd proto*


## Todo

* factor CouchApp Commonjs to jquery.couch.require.js
* use $.couch.app in app.js

## License

Apache 2.0
