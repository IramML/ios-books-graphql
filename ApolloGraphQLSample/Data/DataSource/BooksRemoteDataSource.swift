//
//  BooksRemoteDataSource.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation

protocol BooksRemoteDataSource {
    func getBooks(completion: @escaping ([Book]?, RemoteErrors?) -> Void)
    func getBook(bookId: String, completion: @escaping (Book?, RemoteErrors?) -> Void)
    func createBook(book: Book, completion: @escaping (String?, RemoteErrors?) -> Void)
    func deleteBook(bookId: String, completion: @escaping (Bool?, RemoteErrors?) -> Void)
    func updateBook(bookId: String, book: Book, completion: @escaping (Bool?, RemoteErrors?) -> Void)
}
