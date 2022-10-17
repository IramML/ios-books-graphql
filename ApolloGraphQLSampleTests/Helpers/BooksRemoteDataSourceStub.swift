//
//  BooksRemoteDataSourceStub.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 17/10/22.
//

import Foundation
@testable import ApolloGraphQLSample

class BooksRemoteDataSourceStub: BooksRemoteDataSource {
    private var booksStored: [String: Book] = [:]
    
    func getBooks(completion: @escaping (ApolloGraphQLSample.RemoteResult<[ApolloGraphQLSample.Book]>) -> Void) {
        var books = [anyBook(), anyBook()]
        
        booksStored.forEach { (_: String, value: Book) in
            books.append(value)
        }
        
        completion(.success(books))
    }
    
    func getBook(bookId: String, completion: @escaping (ApolloGraphQLSample.RemoteResult<ApolloGraphQLSample.Book>) -> Void) {
        let book = booksStored[bookId] ?? anyBook(withId: bookId)
        completion(.success(book))
    }
    
    func createBook(book: ApolloGraphQLSample.Book, completion: @escaping (ApolloGraphQLSample.RemoteResult<String>) -> Void) {
        let book = anyBook()
        booksStored[book.id] = book
        completion(.success(book.id))
    }
    
    func deleteBook(bookId: String, completion: @escaping (ApolloGraphQLSample.RemoteResult<Bool>) -> Void) {
        if let bookIndex = booksStored.firstIndex(where: { $0.key == bookId }) {
            booksStored.remove(at: bookIndex)
        }
        
        completion(.success(true))
    }
    
    func updateBook(bookId: String, book: ApolloGraphQLSample.Book, completion: @escaping (ApolloGraphQLSample.RemoteResult<Bool>) -> Void) {
        if booksStored.firstIndex(where: { $0.key == bookId }) != nil {
            booksStored[bookId] = book
        }
        completion(.success(true))
    }
    
    // Mark - helpers
    
    private func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }
}
