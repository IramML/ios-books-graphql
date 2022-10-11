//
//  RemoteResult.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 10/10/22.
//

import Foundation

enum RemoteResult<T> {
    case success(T)
    case failure(RemoteErrors)
}
