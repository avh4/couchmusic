exports.views = {
  
  albums: {
    map: function(doc) {
      emit([doc.artist, doc.album], 1);
    },
    reduce: function(title, count) {
      return sum(count);
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
  }
};
