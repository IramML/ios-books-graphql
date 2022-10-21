//
//  ApolloClientTests.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 18/10/22.
//

import XCTest
@testable import ApolloGraphQLSample
import Apollo

final class ApolloClientTests: XCTestCase {
    
    func test_allInvalidQueryCases() {
        expect(query: GetBooksQuery(), result: nil, error: nil) { (data: GetBooksQuery.Data?, error: NSError?) in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        }
        expect(query: GetBooksQuery(), result: anyGetAllBooksGraphQLData(), error: anyNSError()) { (data: GetBooksQuery.Data?, error: NSError?) in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        }
    }
    func test_allInvalidMutationCases() {
        expect(mutation: CreateBookMutation(book: nil), result: nil, error: nil) { (data: CreateBookMutation.Data?, error: NSError?) in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        }
        expect(mutation: CreateBookMutation(book: nil), result: anyCreateBookMutationGraphQLData(), error: anyNSError()) { (data: CreateBookMutation.Data?, error: NSError?) in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        }
    }

    func test_queryWithSuccessResponse() {
        expect(query: GetBooksQuery(), result: anyGetAllBooksGraphQLData(), error: nil) { (data: GetBooksQuery.Data?, error: NSError?) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            XCTAssertEqual(data!.getAllBooks?.filter { $0 != nil }.count, 2)
        }
    }
    
    func test_queryWithFailureResponse() {
        expect(query: GetBooksQuery(), result: nil, error: anyNSError()) { (data: GetBooksQuery.Data?, error: NSError?) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
        }
    }
    
    func test_mutationWithSuccessRequest() {
        expect(mutation: CreateBookMutation(book: nil), result: anyCreateBookMutationGraphQLData(), error: nil) { (data: GraphQLSelectionSet?, error: NSError?) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
        }
    }
    
    func test_mutationWithFailureRequest() {
        expect(mutation: CreateBookMutation(book: nil), result: nil, error: anyNSError()) { (data: GraphQLSelectionSet?, error: NSError?) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
        }
    }
    
    func expect<Mutation: GraphQLMutation>(mutation: Mutation, result: GraphQLSelectionSet?, error: NSError?, when: @escaping (Mutation.Data?, NSError?) -> Void) {
        let sut = makeSUT()
        
        var response: Mutation.Data? = nil
        let exp = expectation(description: "Wait for query completion")
        
        ApolloClientStub.stub(data: result, error: error)
        
        _ = sut.perform(mutation: mutation, publishResultToStore: false, queue: .main) { result in
            guard let data = try? result.get().data else {
                if let error = error {
                    exp.fulfill()
                    when(nil, error)
                    return
                }
                when(nil, NSError(domain: "Unexpected error", code: 0))
                exp.fulfill()
                return
            }
            response = data
            when(response, nil)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
        
    }
    
    func expect<Query: GraphQLQuery>(query: Query, result: GraphQLSelectionSet?, error: NSError?, when: @escaping (Query.Data?, NSError?) -> Void) {
        let sut = makeSUT()
        
        var response: Query.Data? = nil
        let exp = expectation(description: "Wait for query completion")
        
        ApolloClientStub.stub(data: result, error: error)
        
        _ = sut.fetch(query: query, cachePolicy: .default, contextIdentifier: nil, queue: .main) { result in
            guard let data = try? result.get().data else {
                if let error = error {
                    exp.fulfill()
                    when(nil, error)
                    return
                }
                when(nil, NSError(domain: "Unexpected error", code: 0))
                exp.fulfill()
                return
            }
            response = data
            when(response, nil)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2.0)
        
    }
    
    // MARK - helpers
    func makeSUT() -> ApolloClientStub {
        let client = ApolloClientStub()
        trackForMemoryLeaks(client)
        return client
    }
    
    func anyGetBooksGraphQLData(withId bookId: String = UUID().uuidString) -> GetBooksQuery.Data.GetAllBook {
        GetBooksQuery.Data.GetAllBook(title: "any", id: bookId)
    }
    
    func anyGetAllBooksGraphQLData() -> GetBooksQuery.Data {
        return GetBooksQuery.Data(getAllBooks: [anyGetBooksGraphQLData(), anyGetBooksGraphQLData()])
    }
    
    func anyCreateBookGraphQLData() -> CreateBookMutation.Data.CreateBook {
        CreateBookMutation.Data.CreateBook(id: "any", title: "any")
    }
    
    func anyCreateBookMutationGraphQLData() -> CreateBookMutation.Data {
        CreateBookMutation.Data(createBook: anyCreateBookGraphQLData())
    }
    
    private func jsonToNSData(json: Any) -> NSData? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0, userInfo: nil)
    }
}
