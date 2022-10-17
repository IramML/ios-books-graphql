//
//  BaseRequester.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 17/10/22.
//

import Foundation
import Apollo

class BaseRequester {
    private let apollo = ApolloClient(url: URL(string: Constants.baseGraphQLURL)!)
    
    func perform<Query: GraphQLQuery>(query: Query, completion: @escaping ((GraphQLResult<Query.Data>) -> Void)) {
        apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            guard let data = try? result.get().data else {
                completion(.failure(.httpError))
                return
            }
            completion(.success(data))
        }
    }
    
    func perform<Mutation: GraphQLMutation>(mutation: Mutation, completion: @escaping ((GraphQLResult<Mutation.Data>) -> Void)) {
        apollo.perform(mutation: mutation) { result in
            guard let data = try? result.get().data else {
                completion(.failure(.httpError))
                return
            }
            completion(.success(data))
        }
    }
}


enum GraphQLResult<T> {
    case success(T)
    case failure(RemoteErrors)
}

