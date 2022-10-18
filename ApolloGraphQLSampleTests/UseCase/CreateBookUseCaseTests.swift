//
//  CreateBookUseCaseTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 18/10/22.
//

import XCTest
@testable import ApolloGraphQLSample

final class CreateBookUseCaseTests: XCTestCase {
    
    func test_getBooksUseCase() {
        let (useCase, dataSource) = makeSUT()
        
        let testExpectation = XCTestExpectation()
        var bookIdRetreived: String? = nil
        
        let book: Book = anyBook()
        useCase.invoke(book: book) { result in
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

    // MARK - Helpers
    func makeSUT() -> (useCase: CreateBookUseCase, dataSource: BooksRemoteDataSourceSpy) {
        let dataSource = BooksRemoteDataSourceSpy()
        let repository = BooksRepository(remoteBookDataSource: dataSource)
        let useCase = CreateBookUseCase(booksRepository: repository)
        return (useCase, dataSource)
    }
    
    func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }
}
