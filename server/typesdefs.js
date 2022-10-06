const { gql } = require('apollo-server-express');

const typeDefs = gql`
  type Book {
    id: String
    title: String
    author: String
  }

  type Query {
    hello: String
    getAllBooks: [Book]
    getBook(id: String): Book
  }

  input BookInput {
    title: String
    author: String
  }

  type Mutation {
    createBook(book: BookInput): Book
    deleteBook(id: String): String
    updateBook(id: String, book: BookInput): Book
  }
`;


module.exports = typeDefs;