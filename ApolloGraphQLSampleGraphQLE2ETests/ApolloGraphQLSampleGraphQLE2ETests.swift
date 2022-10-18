//
//  ApolloGraphQLSampleGraphQLE2ETests.swift
//  ApolloGraphQLSampleGraphQLE2ETests
//
//  Created by Iram Martinez on 17/10/22.
//

import XCTest
@testable import ApolloGraphQLSample

final class ApolloGraphQLSampleGraphQLE2ETests: XCTestCase {

    func test_fetchBooks_fromRequester() {
        let booksRequester: BooksRequester = BooksRequester()
        trackForMemoryLeaks(booksRequester)
        var booksRetrieved: [Book]? = nil
        
        let exp = expectation(description: "Wait for load books completion")
        
        booksRequester.getBooks { result in
            switch result {
            case .success(let books):
                booksRetrieved = books
            case .failure(_):
                XCTFail("Error while retreiving books")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
        
        XCTAssertNotNil(booksRetrieved)
    }

    func test_deleteInvalidBook_fromBookFromRequester() {
        let booksRequester: BooksRequester = BooksRequester()
        trackForMemoryLeaks(booksRequester)
        var deletedBook: Bool? = nil
        
        let exp = expectation(description: "Wait for load books completion")
        
        booksRequester.deleteBook(bookId: "invalid-id") { result in
            switch result {
            case .success(let deleted):
                deletedBook = deleted
            case .failure(_):
                XCTFail("Error while retreiving books")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
        
        XCTAssertNotNil(deletedBook)
        XCTAssertFalse(deletedBook!)
    }

}
