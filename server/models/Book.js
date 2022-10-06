const { Schema, model } = require("mongoose");

const bookchema = new Schema({
  title: {
    type: String,
    required: true,
  },
  author: {
    type: String,
  },
});

module.exports = model("Book", bookchema);