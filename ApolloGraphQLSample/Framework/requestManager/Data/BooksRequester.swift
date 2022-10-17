//
//  ApolloBooksDataSource.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation
import Apollo

class BooksRequester: BooksRemoteDataSource {
    private let apollo = ApolloClient(url: URL(string: Constants.baseGraphQLURL)!)
    
    func getBooks(completion: @escaping (RemoteResult<[Book]>) -> Void) {
        apollo.fetch(query: GetBooksQuery(), cachePolicy: .fetchIgnoringCacheCompletely) { result in
            guard let data = try? result.get().data, let books = data.getAllBooks else {
                completion(.failure(.httpError))
                return
            }
            
            completion(.success(books.filter { $0 != nil }.map { $0!.toBookDomain() }))
        }
    }
    
    func getBook(bookId: String, completion: @escaping (RemoteResult<Book>) -> Void) {
        apollo.fetch(query: GetBookQuery(getBookId: bookId), cachePolicy: .fetchIgnoringCacheCompletely) { result in
            guard let data = try? result.get().data, let book = data.getBook else {
                completion(.failure(.httpError))
                return
            }
            
            completion(.success(book.toBookDomain()))
        }
    }
    
    func createBook(book: Book, completion: @escaping (RemoteResult<String>) -> Void) {
        apollo.perform(mutation: CreateBookMutation(book: book.toBookInput())) { result in
            guard let data = try? result.get().data else {
                completion(.failure(.httpError))
                return
            }
            
            if let id = data.createBook?.id {
                completion(.success(id))
            } else {
                completion(.failure(.httpError))
            }
            
        }
    }
    
    func deleteBook(bookId: String, completion: @escaping (RemoteResult<Bool>) -> Void) {
        apollo.perform(mutation: DeleteBookMutation(deleteBookId: bookId)) { result in
            guard let data = try? result.get().data else {
                completion(.failure(.httpError))
                return
            }
            
            completion(.success(data.deleteBook != nil))
        }
    }
    
    func updateBook(bookId: String, book: Book, completion: @escaping (RemoteResult<Bool>) -> Void) {
        apollo.perform(mutation: UpdateBookMutation(updateBookId: bookId, updateBookBook: book.toBookInput())) { result in
            guard let data = try? result.get().data else {
                completion(.failure(.httpError))
                return
            }
            
            completion(.success(data.updateBook != nil))
        }
    }
    
}
