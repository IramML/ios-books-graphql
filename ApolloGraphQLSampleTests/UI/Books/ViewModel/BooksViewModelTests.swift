//
//  BooksViewModelTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 21/10/22.
//

import XCTest
@testable import ApolloGraphQLSample
import SwiftUI

final class BooksViewModelTests: XCTestCase {
    
    func test_getBooks() {
        let (dataSource, viewModel) = makeSUT()
        
        var receivedValue: [Book]? = nil
        let exp = expectation(description: "Wait for fetching books")
        
        let cancelable = viewModel.$books
            .dropFirst()
            .sink { value in
                receivedValue = value
                exp.fulfill()
            }
        viewModel.fetchBooks()
        
        let booksResponse = [anyBook(), anyBook()]
        dataSource.performSuccessGetBooksCompletion(byIndex: 0, books: booksResponse)
        
        wait(for: [exp], timeout: 2.0)
        
        cancelable.cancel()
        
        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.count, 2)
    }
    
    func test_deleteBooks() {
        let (dataSource, viewModel) = makeSUT()
        
        
        viewModel.books = [anyBook(), anyBook(), anyBook()]
        viewModel.deleteItems(offsets: IndexSet(integer: 0))
        
        let exp = expectation(description: "Wait for fetching books")
        
        var receivedValue: [Book]? = nil
        let cancelable = viewModel.$books
            .dropFirst()
            .sink { value in
                receivedValue = value
                exp.fulfill()
            }
        
        let booksResponse = [anyBook(), anyBook()]
        dataSource.performSuccessDeleteBookCompletion(byIndex: 0, completed: true)
        dataSource.performSuccessGetBooksCompletion(byIndex: 0, books: booksResponse)
        
        wait(for: [exp], timeout: 2.0)
        
        cancelable.cancel()
        
        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(receivedValue?.count, 2)
    }
    
    // MARK - helpers
    
    func makeSUT() -> (dataSource: BooksRemoteDataSourceSpy, viewModel: BooksViewModel) {
        let booksRemoteDataSource: BooksRemoteDataSourceSpy = BooksRemoteDataSourceSpy()
        
        let booksRepository: BooksRepository = BooksRepository(remoteBookDataSource: booksRemoteDataSource)
        
        let getBooksUseCase: GetBooksUseCase = GetBooksUseCase(booksRepository: booksRepository)
        let deleteBookUseCase: DeleteBookUseCase = DeleteBookUseCase(booksRepository: booksRepository)
        
        let viewModel = BooksViewModel(getBooksUseCase: getBooksUseCase, deleteBookUseCase: deleteBookUseCase)
        
        trackForMemoryLeaks(booksRemoteDataSource)
        trackForMemoryLeaks(booksRepository)
        trackForMemoryLeaks(getBooksUseCase)
        trackForMemoryLeaks(deleteBookUseCase)
        trackForMemoryLeaks(viewModel)
        return (booksRemoteDataSource, viewModel)
    }
    
    func anyBook(withId bookId: String = UUID().uuidString) -> Book {
        Book(id: bookId, title: "title", author: "author")
    }
}
