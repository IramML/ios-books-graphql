//
//  DeleteBookUseCase.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation

class DeleteBookUseCase {
    private let booksRepository: BooksRepository
    
    init(booksRepository: BooksRepository) {
        self.booksRepository = booksRepository
    }
    
    func invoke(bookId: String, completion: @escaping (RemoteResult<Bool>) -> Void) {
        self.booksRepository.deleteBookFromRemote(bookId: bookId, completion: completion)
    }
}
