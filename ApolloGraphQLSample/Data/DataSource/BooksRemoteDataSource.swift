//
//  BooksRemoteDataSource.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation

protocol BooksRemoteDataSource {
    func getBooks(completion: @escaping (RemoteResult<[Book]>) -> Void)
    func getBook(bookId: String, completion: @escaping (RemoteResult<Book>) -> Void)
    func createBook(book: Book, completion: @escaping (RemoteResult<String>) -> Void)
    func deleteBook(bookId: String, completion: @escaping (RemoteResult<Bool>) -> Void)
    func updateBook(bookId: String, book: Book, completion: @escaping (RemoteResult<Bool>) -> Void)
}
