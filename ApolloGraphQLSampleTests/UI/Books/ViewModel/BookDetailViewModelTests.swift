//
//  BookDetailViewModelTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 21/10/22.
//

import XCTest
@testable import ApolloGraphQLSample

final class BookDetailViewModelTests: XCTestCase {
    
    func test_fetchBook() {
        let (dataSource, viewModel) = makeSUT()
        
        var receivedValue: Book? = nil
        let exp = expectation(description: "Wait for fetching books")
        
        let cancelable = viewModel.$book
            .dropFirst()
            .sink { value in
                receivedValue = value
                exp.fulfill()
            }
        let bookResponse = anyBook()
        viewModel.fetchBook(byId: bookResponse.id)
        dataSource.performSuccessGetBookCompletion(byIndex: 0, book: bookResponse)
        
        wait(for: [exp], timeout: 2.0)
        
        cancelable.cancel()
        
        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.id, bookResponse.id)
        XCTAssertEqual(receivedValue?.title, bookResponse.title)
        XCTAssertEqual(receivedValue?.author, bookResponse.author)
    }
    
    func makeSUT() -> (dataSource: BooksRemoteDataSourceSpy, viewModel: BookDetailViewModel) {
        let booksRemoteDataSource: BooksRemoteDataSourceSpy = BooksRemoteDataSourceSpy()
        
        let booksRepository: BooksRepository = BooksRepository(remoteBookDataSource: booksRemoteDataSource)
        
        let getBookUseCase: GetBookUseCase = GetBookUseCase(booksRepository: booksRepository)
        
        let viewModel = BookDetailViewModel(getBookUseCase: getBookUseCase)
        
        trackForMemoryLeaks(booksRemoteDataSource)
        trackForMemoryLeaks(booksRepository)
        trackForMemoryLeaks(getBookUseCase)
        trackForMemoryLeaks(viewModel)
        return (booksRemoteDataSource, viewModel)
    }
    
    // MARK - helpers
    
    func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }

}
