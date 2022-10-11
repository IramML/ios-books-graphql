//
//  CreateBookUseCase.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation

class CreateBookUseCase {
    private let booksRepository: BooksRepository
    
    init(booksRepository: BooksRepository) {
        self.booksRepository = booksRepository
    }
    
    func invoke(book: Book, completion: @escaping (RemoteResult<String>) -> Void) {
        self.booksRepository.createBookFromRemote(book: book, completion: completion)
    }
}
