//
//  GetBooksUseCaseTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 18/10/22.
//

import XCTest
@testable import ApolloGraphQLSample

final class GetBooksUseCaseTests: XCTestCase {
    
    func test_getBooksUseCase() {
        let (useCase, dataSource) = makeSUT()
        
        let testExpectation = XCTestExpectation()
        var booksRetreived: [Book]? = nil
        
        useCase.invoke { result in
            switch result {
            case let .success(books):
                booksRetreived = books
            case .failure(_):
                XCTFail("Get books from use case failed")
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

    // MARK - Helpers
    func makeSUT() -> (useCase: GetBooksUseCase, dataSource: BooksRemoteDataSourceSpy) {
        let dataSource = BooksRemoteDataSourceSpy()
        let repository = BooksRepository(remoteBookDataSource: dataSource)
        let useCase = GetBooksUseCase(booksRepository: repository)
        return (useCase, dataSource)
    }
    
    func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }
}
