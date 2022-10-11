//
//  GetBookUseCase.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation

class GetBookUseCase {
    private let booksRepository: BooksRepository
    
    init(booksRepository: BooksRepository) {
        self.booksRepository = booksRepository
    }
    
    func invoke(bookId: String, completion: @escaping (RemoteResult<Book>) -> Void) {
        self.booksRepository.getBookFromRemote(bookId: bookId, completion: completion)
    }
}
