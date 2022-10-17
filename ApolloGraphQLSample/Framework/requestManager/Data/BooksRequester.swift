//
//  ApolloBooksDataSource.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation
import Apollo

class BooksRequester: BaseRequester, BooksRemoteDataSource {
    
    func getBooks(completion: @escaping (RemoteResult<[Book]>) -> Void) {
        self.perform(query: GetBooksQuery()) { (result: GraphQLResult) in
            switch result {
            case .success(let data):
                if let books = data.getAllBooks {
                    completion(.success(books.filter { $0 != nil }.map { $0!.toBookDomain() }))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getBook(bookId: String, completion: @escaping (RemoteResult<Book>) -> Void) {
        self.perform(query: GetBookQuery(getBookId: bookId)) { (result: GraphQLResult) in
            switch result {
            case .success(let data):
                if let book = data.getBook {
                    completion(.success(book.toBookDomain()))
                } else {
                    completion(.failure(.castingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func createBook(book: Book, completion: @escaping (RemoteResult<String>) -> Void) {
        self.perform(mutation: CreateBookMutation(book: book.toBookInput())) { (result: GraphQLResult) in
            switch result {
            case .success(let data):
                if let id = data.createBook?.id {
                    completion(.success(id))
                } else {
                    completion(.failure(.castingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteBook(bookId: String, completion: @escaping (RemoteResult<Bool>) -> Void) {
        self.perform(mutation: DeleteBookMutation(deleteBookId: bookId)) { (result: GraphQLResult) in
            switch result {
            case .success(let data):
                completion(.success(data.deleteBook != nil))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateBook(bookId: String, book: Book, completion: @escaping (RemoteResult<Bool>) -> Void) {
        self.perform(mutation: UpdateBookMutation(updateBookId: bookId, updateBookBook: book.toBookInput())) { (result: GraphQLResult) in
            switch result {
            case .success(let data):
                completion(.success(data.updateBook != nil))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
