FeedMe.Views.UserNew = Backbone.View.extend({

  events: {
    "submit form": "createUser"
  },

  template: JST['users/new'],

  render: function () {
    this.$el.html(this.template({ user: this.model}));
    return this;
  },

  createUser: function (event) {
    var user, attrs;
    event.preventDefault();

    attrs = this.$("form").serializeJSON();

    if (attrs.user.password !== attrs.user.password_confirmation) {
      console.log("Password and Confirmation do not match.")
      return;
    } else {
      delete attrs["user"]["password_confirmation"]
      user = new FeedMe.Models.User();
      user.save(attrs, {
        success: function () {
          console.log(user )
          FeedMe.users.add(user);
          Backbone.history.navigate("", { trigger: true });
        },
        error: function () {
          console.log("Error saving new user.");
        }
      });
    }
  }

})