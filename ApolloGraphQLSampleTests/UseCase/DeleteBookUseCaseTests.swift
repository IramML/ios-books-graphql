//
//  DeleteBookUseCaseTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 18/10/22.
//

import XCTest
@testable import ApolloGraphQLSample

final class DeleteBookUseCaseTests: XCTestCase {
    
    func test_getBooksUseCase() {
        let (useCase, dataSource) = makeSUT()
        
        let testExpectation = XCTestExpectation()
       
        var didDelete: Bool? = nil
        
        let bookId: String = UUID().uuidString
        useCase.invoke(bookId: bookId) { result in
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

    // MARK - Helpers
    func makeSUT() -> (useCase: DeleteBookUseCase, dataSource: BooksRemoteDataSourceSpy) {
        let dataSource = BooksRemoteDataSourceSpy()
        let repository = BooksRepository(remoteBookDataSource: dataSource)
        let useCase = DeleteBookUseCase(booksRepository: repository)
        return (useCase, dataSource)
    }
}
