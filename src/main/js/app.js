exports.views = {

  albums: {
    map: function(doc) {
      emit([doc.artist, doc.album], 1);
    },
    reduce: function(title, count) {
      return sum(count);
    }
  },

  duplicates: {
    map: function(doc) {
      emit([doc.artist, doc.album, doc.title], 1);
    },
    reduce: function(keys, values) {
      return sum(values);
    }
  },

  errors: {
    map: function(doc) {
      if (doc.artist == null) {
        emit(["Missing artist", doc._id], doc);
      }
      if (doc.album == null) {
        emit(["Missing album", doc._id], doc);
      }
      if (doc.library == null) {
        emit(["Missing library", doc._id], doc)
      }
    },
    reduce: function(keys, values) {
      if (keys) return keys.length;
      else return sum(values);
    }
  },

  track_identity: {
    map: function(doc) {
      var identifier = [doc.artist, doc.album, doc.track];
      var library = doc.library;
      emit([identifier, library], true);
    }
  },

  album_identity: {
    map: function(doc) {
      var identifier = [doc.artist, doc.album];
      var library = doc.library;
      emit([identifier, library], identifier);
    },
    reduce: function(keys, values) {
      return values[0];
    }
  },

  libraries: {
    map: function(doc) {
      if (doc.library) emit(doc.library, doc.library_path);
      else emit("_no_library", doc._id);
    },
    reduce: function(keys, values) {
      if (keys) return keys.length
      else return sum(values);
    }
  }
};

exports.lists = {
  typeahead: function(head, req) {
    var c = '[';
    while(row = getRow()) {
      send(c + toJSON(row.key));
      c = ',';
    }
    send(']');
  },

  missing: function(head, req) {
    function makeHeader(fromName, toName) {
      return "<h2>Files missing from " + toName + "</h2><ul>";
    }

    function makeReport(row) {
      if (row.id) {
        return "<li>" + row.id + " (" + row.key[0].join(" - ") + ")</li>";
      } else {
        return "<li>" + row.key[0].join(" - ") + "</li>";
      }
    }

    function makeFooter() {
      return "</ul>";
    }

    function missing(inFrom, inTo) {
      return inFrom && !inTo;
    }

    var compare = missing;

    provides("html", function() {
      send(makeHeader(req.query.from, req.query.to));

      var inFrom = false;
      var inTo = false;
      var lastRow = null;
      function processRow() {
        if (lastRow) {
          if (compare(inFrom, inTo)) send(makeReport(lastRow));
        }
      }
      function nextRow(row) {
        lastRow = row;
        inFrom = false;
        inTo = false;
      }
      while(row = getRow()) {
        var identity = row.key[0];
        var source = row.key[1];
        if (!lastRow || lastRow.key[0] != identity) {
          processRow();
          nextRow(row);
        }
        if (source == req.query.from) inFrom = true;
        if (source == req.query.to) inTo = true;
      }
      processRow();
    });
  },

  errors: function(head, req) {
    provides("html", function() {
      var lastError = null;
      while(row = getRow()) {
        error = row.key[0];
        if (lastError != error) {
          if (lastError) send('</ul>');
          send('<h2>' + error + '</h2><ul>\n');
          lastError = error;
        }
        send('<li><b>' + row.key[1] + '</b> <code>' + toJSON(row.value) + '</code></li>');
      }
      if (lastError) send('</ul>');
    });
  }
};
