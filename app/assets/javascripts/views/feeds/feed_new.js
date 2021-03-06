FeedMe.Views.FeedNew = Backbone.View.extend({

  events: {
    "submit form": "createFeed"
  },

  template: JST['feeds/new'],

  render: function () {
    this.$el.html(this.template());
    return this;
  },

  createFeed: function (event) {
    event.preventDefault();
    var feed, feeds, attr;

    feeds = this.collection;
    feed = new FeedMe.Models.Feed();

    attrs = $(event.currentTarget).serializeJSON();
    feed.save(attrs, {
      success: function () {
        feeds.add(feed, { merge: true });
        Backbone.history.navigate("#/feeds/" + feed.id, { trigger: true });
        FeedMe.vent.trigger("noticeFlash", "Feed successfully added.");
      },

      error: function (model, resp) {
        FeedMe.vent.trigger("errorFlash", resp.responseJSON);
      }
    });
  }

})
