//
//  EditBookViewModelTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 21/10/22.
//

import XCTest
@testable import ApolloGraphQLSample

final class EditBookViewModelTests: XCTestCase {
    func test_fetchBook() {
        let (dataSource, viewModel) = makeSUT()
        
        var receivedValue: Bool? = nil
        let exp = expectation(description: "Wait for should dismiss after add book")
        
        let cancelable = viewModel.shouldDismiss
            .sink { value in
                receivedValue = value
                exp.fulfill()
            }
        let bookResponse = anyBook()
        
        viewModel.updateBook(byId: bookResponse.id, book: anyBook())
        dataSource.performSuccessUpdateBookCompletion(byIndex: 0, completed: true)
        
        wait(for: [exp], timeout: 2.0)
        
        cancelable.cancel()
        
        XCTAssertNotNil(receivedValue)
        XCTAssert(receivedValue!)
    }
    
    // MARK - helpers
    
    func makeSUT() -> (dataSource: BooksRemoteDataSourceSpy, viewModel: EditBookViewModel) {
        let booksRemoteDataSource: BooksRemoteDataSourceSpy = BooksRemoteDataSourceSpy()
        
        let booksRepository: BooksRepository = BooksRepository(remoteBookDataSource: booksRemoteDataSource)
        
        let updateBookUseCase: UpdateBookUseCase = UpdateBookUseCase(booksRepository: booksRepository)
        
        let viewModel = EditBookViewModel(updateBookUseCase: updateBookUseCase)
        
        trackForMemoryLeaks(booksRemoteDataSource)
        trackForMemoryLeaks(booksRepository)
        trackForMemoryLeaks(updateBookUseCase)
        trackForMemoryLeaks(viewModel)
        return (booksRemoteDataSource, viewModel)
    }
    
    func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }
}
