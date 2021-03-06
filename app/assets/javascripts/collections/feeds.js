FeedMe.Collections.Feeds = Backbone.Collection.extend({

  url: "/api/feeds",

  model: FeedMe.Models.Feed,

  comparator: "name",

  getOrFetch: function (id) {
    var feed = this.find(id);

    if (feed) {
      feed.fetch();
    } else {
      feed = new FeedMe.Models.Feed( {id: id} );
      feed.fetch({
        success: function () {
          this.add(feed, { merge: true });
        }.bind(this)
      });
    }
    return feed;
  }

});
