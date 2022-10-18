//
//  GetBookUseCaseTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 18/10/22.
//

import XCTest
@testable import ApolloGraphQLSample

final class GetBookUseCaseTests: XCTestCase {
    func test_getBooksUseCase() {
        let (useCase, dataSource) = makeSUT()
        
        let testExpectation = XCTestExpectation()
        var bookRetreived: Book? = nil
        
        let bookId: String = UUID().uuidString
        useCase.invoke(bookId: bookId) { result in
            switch result {
            case let .success(book):
                bookRetreived = book
            case .failure(_):
                XCTFail("Get book from use case failed")
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

    // MARK - Helpers
    func makeSUT() -> (useCase: GetBookUseCase, dataSource: BooksRemoteDataSourceSpy) {
        let dataSource = BooksRemoteDataSourceSpy()
        let repository = BooksRepository(remoteBookDataSource: dataSource)
        let useCase = GetBookUseCase(booksRepository: repository)
        trackForMemoryLeaks(dataSource)
        trackForMemoryLeaks(repository)
        trackForMemoryLeaks(useCase)
        return (useCase, dataSource)
    }
    
    func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }

}
