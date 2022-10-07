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
    
    func getBooksFromRemote(completion: @escaping ([Book]?, RemoteErrors?) -> Void) {
        self.remoteBookDataSource.getBooks(completion: completion)
    }
    
    func getBookFromRemote(bookId: String, completion: @escaping (Book?, RemoteErrors?) -> Void) {
        self.remoteBookDataSource.getBook(bookId: bookId, completion: completion)
    }
    
    func createBookFromRemote(book: Book, completion: @escaping (String?, RemoteErrors?) -> Void) {
        self.createBookFromRemote(book: book, completion: completion)
    }
    
    func deleteBookFromRemote(bookId: String, completion: @escaping (Bool?, RemoteErrors?) -> Void) {
        self.deleteBookFromRemote(bookId: bookId, completion: completion)
    }
    
    func updateBookFromRemote(bookId: String, book: Book, completion: @escaping (Bool?, RemoteErrors?) -> Void) {
        self.updateBookFromRemote(bookId: bookId, book: book, completion: completion)
    }
    
}
