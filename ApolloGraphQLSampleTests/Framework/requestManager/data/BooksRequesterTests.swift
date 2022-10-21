//
//  BooksRequesterTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 18/10/22.
//

import XCTest
@testable import ApolloGraphQLSample
import Apollo

final class BooksRequesterTests: XCTestCase {
    
    func test_getAllBooksWithSuccess() {
        let requester = makeSUT()
       
        ApolloClientStub.stub(data: anyGetAllBooksGraphQLData(), error: nil)
        
        requester.getBooks { (result: RemoteResult<[Book]>) in
            switch result {
            case .success(let books):
                XCTAssertNotNil(books)
                XCTAssertEqual(books.count, 2)
            case .failure(_):
                XCTFail("Get books should be success response")
            }
        }
    }
    
    func test_getAllBooksWithFailure() {
        let requester = makeSUT()
       
        ApolloClientStub.stub(data: nil, error: anyNSError())
        
        requester.getBooks { (result: RemoteResult<[Book]>) in
            switch result {
            case .success(_):
                XCTFail("Get books should be failure response")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func test_getBookWithSuccess() {
        let requester = makeSUT()
       
        let anyBook = anyGetBookGraphQLData()
        ApolloClientStub.stub(data: anyBook, error: nil)
        
        
        requester.getBook(bookId: anyBook.getBook!.id!) { (result: RemoteResult<Book>) in
            switch result {
            case .success(let book):
                XCTAssertNotNil(book)
            case .failure(_):
                XCTFail("Get book should be success response")
            }
        }
    }
    
    func test_getBookWithFailure() {
        let requester = makeSUT()
       
        let anyBook = anyGetBookGraphQLData()
        ApolloClientStub.stub(data: nil, error: anyNSError())
        
        requester.getBook(bookId: anyBook.getBook!.id!) { (result: RemoteResult<Book>) in
            switch result {
            case .success(_):
                XCTFail("Get book should be failure response")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func test_createBookWithSuccess() {
        let requester = makeSUT()
        
        ApolloClientStub.stub(data: anyCreateBookMutationGraphQLData(), error: nil)
        
        requester.createBook(book: anyDomainBook()) { (result: RemoteResult<String>) in
            switch result {
            case .success(let bookId):
                XCTAssertNotNil(bookId)
            case .failure(_):
                XCTFail("Create book should be success response")
            }
        }
    }
    
    func test_createBookWithFailure() {
        let requester = makeSUT()
        
        ApolloClientStub.stub(data: nil, error: anyNSError())
        
        requester.createBook(book: anyDomainBook()) { (result: RemoteResult<String>) in
            switch result {
            case .success(_):
                XCTFail("Get book should be failure response")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func test_deleteBookWithSuccess() {
        let requester = makeSUT()
        
        ApolloClientStub.stub(data: anyDeleteBookMutationGraphQLData(), error: nil)
        
        requester.deleteBook(bookId: "any") { (result: RemoteResult<Bool>) in
            switch result {
            case .success(let deleted):
                XCTAssertNotNil(deleted)
            case .failure(_):
                XCTFail("Delete book should be success response")
            }
        }
    }
    
    func test_deleteBookWithFailure() {
        let requester = makeSUT()
        
        ApolloClientStub.stub(data: nil, error: anyNSError())
        
        requester.deleteBook(bookId: "any") { (result: RemoteResult<Bool>) in
            switch result {
            case .success(_):
                XCTFail("Delete book should be failure response")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func test_updateBookWithSuccess() {
        let requester = makeSUT()
        
        ApolloClientStub.stub(data: anyUpdateBookMutationGraphQLData(), error: nil)
        
        requester.updateBook(bookId: "any", book: anyDomainBook()) { (result: RemoteResult<Bool>) in
            switch result {
            case .success(let updated):
                XCTAssertNotNil(updated)
            case .failure(_):
                XCTFail("Update book should be success response")
            }
        }
    }
    
    func test_updateBookWithFailure() {
        let requester = makeSUT()
        
        ApolloClientStub.stub(data: nil, error: anyNSError())
        
        requester.updateBook(bookId: "any", book: anyDomainBook()) { (result: RemoteResult<Bool>) in
            switch result {
            case .success(_):
                XCTFail("Update book should be failure response")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    // MARK - helpers
    func makeSUT() -> BooksRequester {
        let apolloClient = ApolloClientStub()
        let booksRequester = BooksRequester(client: apolloClient)
        trackForMemoryLeaks(apolloClient)
        trackForMemoryLeaks(booksRequester)
        return booksRequester
    }
    
    func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
    
    func anyDomainBook() -> Book {
        Book(id: "any", title: "any", author: "any")
    }
    
    func anyGetAllBooksGraphQLData() -> GetBooksQuery.Data {
        GetBooksQuery.Data(getAllBooks: [GetBooksQuery.Data.GetAllBook(title: "any", id: UUID().uuidString), GetBooksQuery.Data.GetAllBook(title: "any", id: UUID().uuidString)])
    }
    
    func anyGetBookGraphQLData() -> GetBookQuery.Data {
        GetBookQuery.Data(getBook: GetBookQuery.Data.GetBook(id: "any", title: "any", author: "any"))
    }
    
    func anyCreateBookMutationGraphQLData() -> CreateBookMutation.Data {
        CreateBookMutation.Data(createBook: CreateBookMutation.Data.CreateBook(id: "any", title: "any"))
    }
    
    func anyDeleteBookMutationGraphQLData() -> DeleteBookMutation.Data {
        DeleteBookMutation.Data(deleteBook: "any")
    }
    
    func anyUpdateBookMutationGraphQLData() -> UpdateBookMutation.Data {
        UpdateBookMutation.Data(updateBook: UpdateBookMutation.Data.UpdateBook(id: "any", title: "any"))
    }
}

