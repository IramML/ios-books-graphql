//
//  BooksRepository.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation

class BooksRepository {
    private let remoteBookDataSource: BooksRemoteDataSource
    
    init(remoteBookDataSource: BooksRemoteDataSource) {
        self.remoteBookDataSource = remoteBookDataSource
    }
    
    func getBooksFromRemote(completion: @escaping (RemoteResult<[Book]>) -> Void) {
        self.remoteBookDataSource.getBooks(completion: completion)
    }
    
    func getBookFromRemote(bookId: String, completion: @escaping (RemoteResult<Book>) -> Void) {
        self.remoteBookDataSource.getBook(bookId: bookId, completion: completion)
    }
    
    func createBookFromRemote(book: Book, completion: @escaping (RemoteResult<String>) -> Void) {
        self.remoteBookDataSource.createBook(book: book, completion: completion)
    }
    
    func deleteBookFromRemote(bookId: String, completion: @escaping (RemoteResult<Bool>) -> Void) {
        self.remoteBookDataSource.deleteBook(bookId: bookId, completion: completion)
    }
    
    func updateBookFromRemote(bookId: String, book: Book, completion: @escaping (RemoteResult<Bool>) -> Void) {
        self.remoteBookDataSource.updateBook(bookId: bookId, book: book, completion: completion)
    }
    
}
