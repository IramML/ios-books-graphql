const Book = require("./models/Book");
 
const resolvers = { 
    Query: {
        hello: () => "Hello world",
        getAllBooks: async () => {
          const book = await Book.find();
          return book;
        },
        async getBook(_, { id }) {
          return await Book.findById(id);
        },
      },
    Mutation: {
        async createBook(parent, { book }, context, info) {
          const { title, author } = book;
          const newBook = new Book({ title, author });
          await newBook.save();
          return newBook;
        },
        async deleteBook(_, { id }) {
          await Book.findByIdAndDelete(id);
          return "Book Deleted";
        },
        async updateBook(_, { id, book }) {
          const { title, author } = book;
          const newBook = await Book.findByIdAndUpdate(
            id,
            {
              $set: {
                title,
                author,
              },
            },
            {
              new: true,
            }
          );
          return newBook;
        },
      },
}

module.exports = resolvers;