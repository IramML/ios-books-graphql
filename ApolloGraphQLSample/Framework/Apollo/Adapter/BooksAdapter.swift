//
//  BooksAdapter.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation

extension Book {
    func toBookInput() -> BookInput {
        BookInput(title: self.title, author: self.author)
    }
}

extension GetBooksQuery.Data.GetAllBook{
    func toBookDomain() -> Book {
        Book(id: self.id!, title: self.title!, author: "")
    }
}
extension GetBookQuery.Data.GetBook{
    func toBookDomain() -> Book {
        Book(id: self.id!, title: self.title!, author: self.author!)
    }
}
