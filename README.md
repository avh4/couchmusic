
## Initial setup

Copy `_couchmusic.json.example` to `~/.couchmusic.json`, and edit it to point
to your CouchDB database.

Run the following command to set the CouchDB username and password that
couchmusic will use to connect to the database:

    (read -p User: USER; read -sp Password: PASS; echo; security add-generic-password -s couchmusic -a $USER -p $PASS -U)
