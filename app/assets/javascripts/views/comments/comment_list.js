FeedMe.Views.CommentList = Backbone.ListView.extend({

  initialize: function (options) {
    this._elemViews = [];
    this.listenTo(this.collection, "add remove reset sync", this.clearElemViews);
    this.listenTo(this.collection, "add remove reset sync", this.render);
    this.commentableType = options.commentableType;
    this.commentableId = options.commentableId;
  },

  tagName: "ul",

  className: "comment-list gen-list closed",

  template: JST['comments/list'],
  render: function () {

    this.$el.html(this.template());
    if (this._elemViews.length === 0) {
      this.updateViews()
    }
    this.attachElemViews();
    return this;
  },

  updateViews: function () {
    this.collection.each(function (comment) {
      var commentView = new FeedMe.Views.CommentShow( {
        model: comment,
        parent: this
        });
      this._elemViews.push(commentView);
    }.bind(this));
    this.createFormView();
  },

  attachElemViews: function () {
    this._elemViews.forEach(function (elemView) {
      this.$el.append(elemView.render().$el);
    }.bind(this));
  },

  createFormView: function () {
    var commentForm = new FeedMe.Views.CommentForm( {
      collection: this.collection,
      commentableType: this.commentableType,
      commentableId: this.commentableId,
      parent: this,
      model: new FeedMe.Models.Comment()
    });

    this._elemViews.push(commentForm);
  }

});
