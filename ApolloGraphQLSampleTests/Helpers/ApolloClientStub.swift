//
//  ApolloClientStub.swift
//  ApolloGraphQLSampleTests
//
//  Created by Iram Martinez on 18/10/22.
//

import Foundation
import Apollo

class ApolloClientStub: ApolloClientProtocol {
    var store: Apollo.ApolloStore
    var cacheKeyForObject: Apollo.CacheKeyForObject?
    
    private static var stub: Stub? = nil
    
    private struct Stub {
        let result: GraphQLSelectionSet?
        let error: NSError?
    }
    
    init() {
        store = ApolloStore(cache: InMemoryNormalizedCache())
        resetStub()
    }
    
    func clearCache(callbackQueue: DispatchQueue, completion: ((Result<Void, Error>) -> Void)?) {
        fatalError()
    }
    
    func fetch<Query>(query: Query, cachePolicy: Apollo.CachePolicy, contextIdentifier: UUID?, queue: DispatchQueue, resultHandler: Apollo.GraphQLResultHandler<Query.Data>?) -> Apollo.Cancellable where Query : Apollo.GraphQLQuery {
        guard let stub = ApolloClientStub.stub, !(stub.result != nil && stub.error != nil) else {
            resultHandler?(.failure(NSError(domain: "Unexpected error", code: 0)))
            return CancellableFake()
        }
        
        if let data = stub.result {
            let result = GraphQLResult(data: data as? Query.Data, extensions: nil, errors: nil, source: .cache, dependentKeys: nil)
            resultHandler?(.success(result))
        } else if let error = stub.error {
            resultHandler?(.failure(error))
        } else {
            resultHandler?(.failure(NSError(domain: "Unexpected error", code: 0)))
        }
        
        return CancellableFake()
    }
    
    func watch<Query>(query: Query, cachePolicy: Apollo.CachePolicy, callbackQueue: DispatchQueue, resultHandler: @escaping Apollo.GraphQLResultHandler<Query.Data>) -> Apollo.GraphQLQueryWatcher<Query> where Query : Apollo.GraphQLQuery {
        fatalError()
    }
    
    func perform<Mutation>(mutation: Mutation, publishResultToStore: Bool, queue: DispatchQueue, resultHandler: Apollo.GraphQLResultHandler<Mutation.Data>?) -> Apollo.Cancellable where Mutation : Apollo.GraphQLMutation {
        guard let stub = ApolloClientStub.stub, !(stub.result != nil && stub.error != nil) else {
            resultHandler?(.failure(NSError(domain: "Unexpected error", code: 0)))
            return CancellableFake()
        }
        
        if let data = stub.result {
            let result = GraphQLResult(data: data as? Mutation.Data, extensions: nil, errors: nil, source: .cache, dependentKeys: nil)
            resultHandler?(.success(result))
        } else if let error = stub.error {
            resultHandler?(.failure(error))
        } else {
            resultHandler?(.failure(NSError(domain: "Unexpected error", code: 0)))
        }
        
        return CancellableFake()
    }
    
    func upload<Operation>(operation: Operation, files: [Apollo.GraphQLFile], queue: DispatchQueue, resultHandler: Apollo.GraphQLResultHandler<Operation.Data>?) -> Apollo.Cancellable where Operation : Apollo.GraphQLOperation {
        fatalError()
    }
    
    func subscribe<Subscription>(subscription: Subscription, queue: DispatchQueue, resultHandler: @escaping Apollo.GraphQLResultHandler<Subscription.Data>) -> Apollo.Cancellable where Subscription : Apollo.GraphQLSubscription {
        fatalError()
    }
    
    static func stub(data: GraphQLSelectionSet?, error: NSError?) {
        ApolloClientStub.stub = Stub(result: data, error: error)
    }
    
    private func resetStub() {
        ApolloClientStub.stub = nil
    }
    
    class CancellableFake: Apollo.Cancellable {
        func cancel() {
            
        }
    }
    
}
