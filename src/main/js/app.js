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
        emit(["Missing artist", doc._id], 1);
      }
      if (doc.album == null) {
        emit(["Missing album", doc._id], 1);
      }
    },
    reduce: function(title, count) {
      return sum(count);
    }
  },

  track_identity: {
    map: function(doc) {
      var identifier = [doc.artist, doc.album, doc.track];
      var library = doc._id.split(":")[0];
      emit([identifier, library], true);
    }
  },

  album_identity: {
    map: function(doc) {
      var identifier = [doc.artist, doc.album];
      var library = doc._id.split(":")[0];
      emit([identifier, library], identifier);
    },
    reduce: function(keys, values) {
      return values[0];
    }
  }
};

exports.lists = {
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
  }
};
