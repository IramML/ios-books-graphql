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
        let repository = createSpyRepositorySpy()
        
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
        
        wait(for: [testExpectation], timeout: 1.0)
        
        XCTAssertNotNil(booksRetreived)
        XCTAssertEqual(booksRetreived!.count, 2)
        XCTAssertEqual(repository.countGetBooksFromRemote, 1)
    }
    
    func test_getBookByIdFromRemote() {
        let repository = createSpyRepositorySpy()
        let bookId: String = UUID().uuidString
        
        let testExpectation = XCTestExpectation()
        var bookRetreived: Book? = nil
        
        repository.getBookFromRemote(bookId: bookId) { result in
            switch result {
            case let .success(book):
                bookRetreived = book
            case .failure(_):
                XCTFail("Get book from remote failed")
            }
            
            testExpectation.fulfill()
        }
        
        wait(for: [testExpectation], timeout: 1.0)
        
        XCTAssertNotNil(bookRetreived)
        XCTAssertEqual(bookRetreived!.id, bookId)
        XCTAssertEqual(repository.getBookFromRemoteCallsIds, [bookId])
    }
    
    func test_createBookFromRemote() {
        let repository = createSpyRepositorySpy()
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
        
        wait(for: [testExpectation], timeout: 1.0)
        
        XCTAssertNotNil(bookIdRetreived)
        XCTAssertEqual(repository.createBookFromRemoteBooks.count, 1)
    }
    
    func test_deleteBookFromRemote() {
        let repository = createSpyRepositorySpy()
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
        
        wait(for: [testExpectation], timeout: 1.0)
        
        XCTAssertNotNil(didDelete)
        XCTAssertEqual(repository.deleteBookFromRemoteCallsIds, [bookId])
    }
    
    func test_updateBookFromRemote() {
        let repository = createSpyRepositorySpy()
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
        
        wait(for: [testExpectation], timeout: 1.0)
        
        XCTAssertNotNil(didUpdate)
        XCTAssertEqual(repository.updateBookFromRemoteCallsParams.count, 1)
        let bookUpdated = repository.updateBookFromRemoteCallsParams.first
        XCTAssertNotNil(bookUpdated)
        XCTAssertEqual(bookUpdated!.bookId, bookId)
        XCTAssertEqual(bookUpdated!.book.id, book.id)
        XCTAssertEqual(bookUpdated!.book.title, book.title)
        XCTAssertEqual(bookUpdated!.book.author, book.author)
    }
    
    // MARK - helpers
    func createSpyRepositorySpy() -> BooksRepositorySpy {
        let remoteBookDataSource = BooksRemoteDataSourceStub()
        let repository = BooksRepositorySpy(remoteBookDataSource: remoteBookDataSource)
        trackForMemoryLeaks(remoteBookDataSource)
        trackForMemoryLeaks(repository)
        return repository
    }
    
    func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }
}

class BooksRepositorySpy: BooksRepository {
    private(set) var countGetBooksFromRemote: Int = 0
    private(set) var getBookFromRemoteCallsIds: [String] = []
    private(set) var createBookFromRemoteBooks: [Book] = []
    private(set) var deleteBookFromRemoteCallsIds: [String] = []
    private(set) var updateBookFromRemoteCallsParams: [(bookId: String, book: Book)] = []
    
    override func getBooksFromRemote(completion: @escaping (RemoteResult<[Book]>) -> Void) {
        countGetBooksFromRemote += 1
        super.getBooksFromRemote(completion: completion)
    }
    
    override func getBookFromRemote(bookId: String, completion: @escaping (RemoteResult<Book>) -> Void) {
        getBookFromRemoteCallsIds.append(bookId)
        super.getBookFromRemote(bookId: bookId, completion: completion)
    }
    
    override func createBookFromRemote(book: Book, completion: @escaping (RemoteResult<String>) -> Void) {
        createBookFromRemoteBooks.append(book)
        super.createBookFromRemote(book: book, completion: completion)
    }
    
    override func deleteBookFromRemote(bookId: String, completion: @escaping (RemoteResult<Bool>) -> Void) {
        deleteBookFromRemoteCallsIds.append(bookId)
        super.deleteBookFromRemote(bookId: bookId, completion: completion)
    }
    
    override func updateBookFromRemote(bookId: String, book: Book, completion: @escaping (RemoteResult<Bool>) -> Void) {
        updateBookFromRemoteCallsParams.append((bookId: bookId, book: book))
        super.updateBookFromRemote(bookId: bookId, book: book, completion: completion)
    }
}
