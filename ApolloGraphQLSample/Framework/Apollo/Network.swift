//
//  Network.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import Foundation
import Apollo

class Network {
    static let shared = Network()

    private(set) lazy var apollo = ApolloClient(url: URL(string: "http://192.168.1.106:3000/api")!)
    
    func fetchBooks(completion: @escaping ([Book]?, ApolloErrors?) -> Void) {
        apollo.fetch(query: GetBooksQuery(), cachePolicy: .fetchIgnoringCacheCompletely) { result in
            guard let data = try? result.get().data, let books = data.getAllBooks else {
                completion(nil, .noResult)
                return
            }
            
            completion(books.filter { $0 != nil }.map { $0!.toBookDomain() }, nil)
        }
    }
    
    func createBook(book: Book, completion: @escaping (String?, ApolloErrors?) -> Void) {
        apollo.perform(mutation: CreateBookMutation(book: BookInput(title: book.title, author: book.author))) { result in
            guard let data = try? result.get().data else {
                completion(nil, .noResult)
                return
            }
            
            if let id = data.createBook?.id {
                completion(id, nil)
            } else {
                completion(nil, .noResult)
            }
            
        }
    }
    
    func deleteBook(bookId: String, completion: @escaping (Bool?, ApolloErrors?) -> Void) {
        apollo.perform(mutation: DeleteBookMutation(deleteBookId: bookId)) { result in
            guard let data = try? result.get().data else {
                completion(nil, .noResult)
                return
            }
            
            if let bookDeleted = data.deleteBook {
                completion(true, nil)
            } else {
                completion(true, nil)
            }
        }
    }
}

extension GetBooksQuery.Data.GetAllBook{
    func toBookDomain() -> Book {
        Book(id: self.id!, title: self.title!, author: "")
    }
}

enum ApolloErrors {
    case noResult, castingError
}
