//
//  BooksRemoteDataSourceSpy.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 18/10/22.
//

import Foundation
@testable import ApolloGraphQLSample

final class BooksRemoteDataSourceSpy: BooksRemoteDataSource {
    private var booksStored: [String: Book] = [:]
    
    private(set) var receivedRequests: [ReceivedRequest] = []
    enum ReceivedRequest: Equatable {
        static func == (lhs: ReceivedRequest, rhs: ReceivedRequest) -> Bool {
            switch (lhs, rhs) {
            case (.getBooks, .getBooks):
                return true
            case (.getBook(let bookIdLhs), .getBook(let bookIdRhs)):
                return bookIdLhs == bookIdRhs
            case (.createBook(let bookLhs), .createBook(let bookRhs)):
                return (bookLhs.id == bookRhs.id) && (bookLhs.title == bookRhs.title) && (bookLhs.author == bookRhs.author)
            case (.deleteBook(let bookIdLhs), .deleteBook(let bookIdRhs)):
                return bookIdLhs == bookIdRhs
            case (.updateBook(let bookIdLhs, let bookLhs), .updateBook(let bookIdRhs, let bookRhs)):
                return bookIdLhs == bookIdRhs && ((bookLhs.id == bookRhs.id) && (bookLhs.title == bookRhs.title) && (bookLhs.author == bookRhs.author))
            default:
                return false
            }
        }
        
        case getBooks
        case getBook(bookId: String)
        case createBook(book: Book)
        case deleteBook(bookId: String)
        case updateBook(bookId: String, book: Book)
    }
    
    private var getBooksCompletions: [(RemoteResult<[Book]>) -> Void] = []
    private var getBookCompletions: [(RemoteResult<Book>) -> Void] = []
    private var createBookCompletions: [(RemoteResult<String>) -> Void] = []
    private var deleteBookCompletions: [(RemoteResult<Bool>) -> Void] = []
    private var updateBookCompletions: [(RemoteResult<Bool>) -> Void] = []
    
    func getBooks(completion: @escaping (ApolloGraphQLSample.RemoteResult<[ApolloGraphQLSample.Book]>) -> Void) {
        receivedRequests.append(.getBooks)
        getBooksCompletions.append(completion)
    }
    
    func getBook(bookId: String, completion: @escaping (ApolloGraphQLSample.RemoteResult<ApolloGraphQLSample.Book>) -> Void) {
        receivedRequests.append(.getBook(bookId: bookId))
        getBookCompletions.append(completion)
    }
    
    func createBook(book: ApolloGraphQLSample.Book, completion: @escaping (ApolloGraphQLSample.RemoteResult<String>) -> Void) {
        receivedRequests.append(.createBook(book: book))
        createBookCompletions.append(completion)
    }
    
    func deleteBook(bookId: String, completion: @escaping (ApolloGraphQLSample.RemoteResult<Bool>) -> Void) {
        receivedRequests.append(.deleteBook(bookId: bookId))
        deleteBookCompletions.append(completion)
    }
    
    func updateBook(bookId: String, book: ApolloGraphQLSample.Book, completion: @escaping (ApolloGraphQLSample.RemoteResult<Bool>) -> Void) {
        receivedRequests.append(.updateBook(bookId: bookId, book: book))
        updateBookCompletions.append(completion)
    }
    
    func performSuccessGetBooksCompletion(byIndex index: Int, books: [Book]) {
        getBooksCompletions[index](.success(books))
    }
    
    func performFailureGetBooksCompletion(byIndex index: Int, error: RemoteErrors) {
        getBooksCompletions[index](.failure(error))
    }
    
    func performSuccessGetBookCompletion(byIndex index: Int, book: Book) {
        getBookCompletions[index](.success(book))
    }
    
    func performFailureGetBookCompletion(byIndex index: Int, error: RemoteErrors) {
        getBookCompletions[index](.failure(error))
    }
    
    func performSuccessCreateBookCompletion(byIndex index: Int, bookId: String) {
        createBookCompletions[index](.success(bookId))
    }
    
    func performFailureCreateBookCompletion(byIndex index: Int, error: RemoteErrors) {
        createBookCompletions[index](.failure(error))
    }
    
    func performSuccessDeleteBookCompletion(byIndex index: Int, completed: Bool) {
        deleteBookCompletions[index](.success(completed))
    }
    
    func performFailureDeleteBookCompletion(byIndex index: Int, error: RemoteErrors) {
        deleteBookCompletions[index](.failure(error))
    }
    
    func performSuccessUpdateBookCompletion(byIndex index: Int, completed: Bool) {
        updateBookCompletions[index](.success(completed))
    }
    
    func performFailureUpdateBookCompletion(byIndex index: Int, error: RemoteErrors) {
        updateBookCompletions[index](.failure(error))
    }
    
    // Mark - helpers
    
    private func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }
}
