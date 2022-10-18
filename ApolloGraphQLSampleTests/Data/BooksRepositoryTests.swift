//
//  BooksRepositoryTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 17/10/22.
//

import XCTest
@testable import ApolloGraphQLSample

final class BooksRepositoryTests: XCTestCase {
    
    func test_getBooksFromRemote() {
        let (repository, dataSource) = makeSUT()
        
        let testExpectation = XCTestExpectation()
        var booksRetreived: [Book]? = nil
        
        repository.getBooksFromRemote { result in
            switch result {
            case let .success(books):
                booksRetreived = books
            case .failure(_):
                XCTFail("Get books from remote failed")
            }
            
            testExpectation.fulfill()
        }
        
        let booksResponse = [anyBook(), anyBook()]
        dataSource.performSuccessGetBooksCompletion(byIndex: 0, books: booksResponse)
        
        wait(for: [testExpectation], timeout: 1.0)
        
        XCTAssertNotNil(booksRetreived)
        XCTAssertEqual(booksRetreived!.count, 2)
        XCTAssertEqual(booksRetreived![0].id, booksResponse[0].id)
        XCTAssertEqual(booksRetreived![1].id, booksResponse[1].id)
        XCTAssertEqual(dataSource.receivedRequests, [.getBooks])
    }
    
    func test_getBookByIdFromRemote() {
        let (repository, dataSource) = makeSUT()
        
        let testExpectation = XCTestExpectation()
        var bookRetreived: Book? = nil
        
        let bookId: String = UUID().uuidString
        repository.getBookFromRemote(bookId: bookId) { result in
            switch result {
            case let .success(book):
                bookRetreived = book
            case .failure(_):
                XCTFail("Get book from remote failed")
            }
            
            testExpectation.fulfill()
        }
        
        let response: Book = anyBook(withId: bookId)
        dataSource.performSuccessGetBookCompletion(byIndex: 0, book: response)
        
        wait(for: [testExpectation], timeout: 1.0)
        
        XCTAssertNotNil(bookRetreived)
        XCTAssertEqual(bookRetreived!.id, response.id)
        XCTAssertEqual(dataSource.receivedRequests, [.getBook(bookId: bookId)])
    }
    
    func test_createBookFromRemote() {
        let (repository, dataSource) = makeSUT()
        let book: Book = anyBook()
        
        let testExpectation = XCTestExpectation()
       
        var bookIdRetreived: String? = nil
        
        repository.createBookFromRemote(book: book) { result in
            switch result {
            case let .success(bookId):
                bookIdRetreived = bookId
            case .failure(_):
                XCTFail("Get create book from remote failed")
            }
            testExpectation.fulfill()
        }
        
        let bookId = book.id
        dataSource.performSuccessCreateBookCompletion(byIndex: 0, bookId: bookId)
        
        wait(for: [testExpectation], timeout: 1.0)
        
        XCTAssertNotNil(bookIdRetreived)
        XCTAssertEqual(dataSource.receivedRequests, [.createBook(book: book)])
    }
    
    func test_deleteBookFromRemote() {
        let (repository, dataSource) = makeSUT()
        let bookId: String = UUID().uuidString
        
        let testExpectation = XCTestExpectation()
       
        var didDelete: Bool? = nil
        
        repository.deleteBookFromRemote(bookId: bookId) { result in
            switch result {
            case let .success(deleted):
                didDelete = deleted
            case .failure(_):
                XCTFail("Delete book from remote failed")
            }
            testExpectation.fulfill()
        }
        let response = true
        dataSource.performSuccessDeleteBookCompletion(byIndex: 0, completed: response)
        wait(for: [testExpectation], timeout: 1.0)
        
        XCTAssertNotNil(didDelete)
        XCTAssertEqual(didDelete, response)
        XCTAssertEqual(dataSource.receivedRequests, [.deleteBook(bookId: bookId)])
    }
    
    func test_updateBookFromRemote() {
        let (repository, dataSource) = makeSUT()
        let bookId: String = UUID().uuidString
        let book: Book = anyBook(withId: bookId)
        
        let testExpectation = XCTestExpectation()
       
        var didUpdate: Bool? = nil
        
        repository.updateBookFromRemote(bookId: bookId, book: book) { result in
            switch result {
            case let .success(updated):
                didUpdate = updated
            case .failure(_):
                XCTFail("Update book from remote failed")
            }
            testExpectation.fulfill()
        }
        let response = true
        dataSource.performSuccessUpdateBookCompletion(byIndex: 0, completed: response)
        wait(for: [testExpectation], timeout: 1.0)
        
        XCTAssertNotNil(didUpdate)
        XCTAssertEqual(didUpdate, response)
        XCTAssertEqual(dataSource.receivedRequests, [.updateBook(bookId: bookId, book: book)])
    }
    
    // MARK - helpers
    private final class BooksRemoteDataSourceSpy: BooksRemoteDataSource {
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

    
    private func makeSUT() -> (repository: BooksRepository, dataSource: BooksRemoteDataSourceSpy) {
        let dataSource = BooksRemoteDataSourceSpy()
        let repository = BooksRepository(remoteBookDataSource: dataSource)
        trackForMemoryLeaks(dataSource)
        trackForMemoryLeaks(repository)
        return (repository, dataSource)
    }
    
    func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }
}
