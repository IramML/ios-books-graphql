//
//  UpdateBookUseCase.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 06/10/22.
//

import Foundation

class UpdateBookUseCase {
    private let booksRepository: BooksRepository
    
    init(booksRepository: BooksRepository) {
        self.booksRepository = booksRepository
    }
    
    func invoke(bookId: String, book: Book, completion: @escaping (RemoteResult<Bool>) -> Void) {
        self.booksRepository.updateBookFromRemote(bookId: bookId, book: book, completion: completion)
    }
}
