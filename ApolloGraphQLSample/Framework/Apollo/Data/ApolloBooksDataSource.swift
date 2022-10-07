//
//  ApolloBooksDataSource.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation
import Apollo

class ApolloBooksDataSource: BooksRemoteDataSource {
    private let apollo = ApolloClient(url: URL(string: ApolloConstants.baseURL)!)
    
    func getBooks(completion: @escaping ([Book]?, RemoteErrors?) -> Void) {
        apollo.fetch(query: GetBooksQuery(), cachePolicy: .fetchIgnoringCacheCompletely) { result in
            guard let data = try? result.get().data, let books = data.getAllBooks else {
                completion(nil, .httpError)
                return
            }
            
            completion(books.filter { $0 != nil }.map { $0!.toBookDomain() }, nil)
        }
    }
    
    func getBook(bookId: String, completion: @escaping (Book?, RemoteErrors?) -> Void) {
        apollo.fetch(query: GetBookQuery(getBookId: bookId), cachePolicy: .fetchIgnoringCacheCompletely) { result in
            guard let data = try? result.get().data, let book = data.getBook else {
                completion(nil, .httpError)
                return
            }
            
            completion(book.toBookDomain(), nil)
        }
    }
    
    func createBook(book: Book, completion: @escaping (String?, RemoteErrors?) -> Void) {
        apollo.perform(mutation: CreateBookMutation(book: book.toBookInput())) { result in
            guard let data = try? result.get().data else {
                completion(nil, .httpError)
                return
            }
            
            if let id = data.createBook?.id {
                completion(id, nil)
            } else {
                completion(nil, .httpError)
            }
            
        }
    }
    
    func deleteBook(bookId: String, completion: @escaping (Bool?, RemoteErrors?) -> Void) {
        apollo.perform(mutation: DeleteBookMutation(deleteBookId: bookId)) { result in
            guard let data = try? result.get().data else {
                completion(nil, .httpError)
                return
            }
            
            completion(data.deleteBook != nil, nil)
        }
    }
    
    func updateBook(bookId: String, book: Book, completion: @escaping (Bool?, RemoteErrors?) -> Void) {
        apollo.perform(mutation: UpdateBookMutation(updateBookId: bookId, updateBookBook: book.toBookInput())) { result in
            guard let data = try? result.get().data else {
                completion(nil, .httpError)
                return
            }
            
            completion(data.updateBook != nil, nil)
        }
    }
    
}
