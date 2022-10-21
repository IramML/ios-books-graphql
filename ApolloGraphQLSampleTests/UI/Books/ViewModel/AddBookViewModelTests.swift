//
//  AddBookViewModelTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 21/10/22.
//

import XCTest
@testable import ApolloGraphQLSample

final class AddBookViewModelTests: XCTestCase {
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
        viewModel.addBook(title: bookResponse.title, author: bookResponse.author)
        dataSource.performSuccessCreateBookCompletion(byIndex: 0, bookId: bookResponse.id)
        
        wait(for: [exp], timeout: 2.0)
        
        cancelable.cancel()
        
        XCTAssertNotNil(receivedValue)
        XCTAssert(receivedValue!)
    }
    
    // MARK - helpers
    
    func makeSUT() -> (dataSource: BooksRemoteDataSourceSpy, viewModel: AddBookViewModel) {
        let booksRemoteDataSource: BooksRemoteDataSourceSpy = BooksRemoteDataSourceSpy()
        
        let booksRepository: BooksRepository = BooksRepository(remoteBookDataSource: booksRemoteDataSource)
        
        let createBookUseCase: CreateBookUseCase = CreateBookUseCase(booksRepository: booksRepository)
        
        let viewModel = AddBookViewModel(createBookUseCase: createBookUseCase)
        
        trackForMemoryLeaks(booksRemoteDataSource)
        trackForMemoryLeaks(booksRepository)
        trackForMemoryLeaks(createBookUseCase)
        trackForMemoryLeaks(viewModel)
        return (booksRemoteDataSource, viewModel)
    }
    
    func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }
}
