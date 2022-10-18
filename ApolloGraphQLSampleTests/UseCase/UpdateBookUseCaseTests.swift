//
//  UpdateBookUseCaseTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 18/10/22.
//

import XCTest
@testable import ApolloGraphQLSample

final class UpdateBookUseCaseTests: XCTestCase {
    func test_getBooksUseCase() {
        let (useCase, dataSource) = makeSUT()
        
        let testExpectation = XCTestExpectation()
        var didUpdate: Bool? = nil
        
        let bookId: String = UUID().uuidString
        let book: Book = anyBook(withId: bookId)
        useCase.invoke(bookId: bookId, book: book) { result in
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

    // MARK - Helpers
    func makeSUT() -> (useCase: UpdateBookUseCase, dataSource: BooksRemoteDataSourceSpy) {
        let dataSource = BooksRemoteDataSourceSpy()
        let repository = BooksRepository(remoteBookDataSource: dataSource)
        let useCase = UpdateBookUseCase(booksRepository: repository)
        return (useCase, dataSource)
    }
    
    func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }
}
