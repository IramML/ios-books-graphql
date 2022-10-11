//
//  BookDetailViewModel.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 10/10/22.
//

import Foundation
import SwiftUI

class BookDetailViewModel: ObservableObject {
    @Published var isFetching: Bool = false
    @Published var book: Book? = nil
    
    private let getBookUseCase: GetBookUseCase
    
    init(getBookUseCase: GetBookUseCase) {
        self.getBookUseCase = getBookUseCase
    }
    
    func fetchBook(byId bookId: String) {
        isFetching = true
        self.getBookUseCase.invoke(bookId: bookId) { [weak self] result in
            self?.isFetching = false
            switch result {
            case let .success(book):
                self?.book = book
            case .failure(_):
                break
            }
            
        }
    }
}
