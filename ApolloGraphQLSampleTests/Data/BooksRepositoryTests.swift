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
        
        let testExpectation = XCTestExpectation()
        var bookIdRetreived: String? = nil
        
        let book: Book = anyBook()
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
        
        let testExpectation = XCTestExpectation()
        var didUpdate: Bool? = nil
        
        let bookId: String = UUID().uuidString
        let book: Book = anyBook(withId: bookId)
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
