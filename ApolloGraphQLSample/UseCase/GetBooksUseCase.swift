//
//  GetBooksUseCase.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation

class GetBooksUseCase {
    private let booksRepository: BooksRepository
    
    init(booksRepository: BooksRepository) {
        self.booksRepository = booksRepository
    }
    
    func invoke(completion: @escaping ([Book]?, RemoteErrors?) -> Void) {
        self.booksRepository.getBooksFromRemote(completion: completion)
    }
}
