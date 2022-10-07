//
//  AddBookViewModel.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import Foundation
import SwiftUI

class AddBookViewModel: ObservableObject {
    private let createBookUseCase: CreateBookUseCase
    @Published var shouldDismiss: Bool = false
    
    init(createBookUseCase: CreateBookUseCase) {
        self.createBookUseCase = createBookUseCase
    }
    
    func addBook(title: String, author: String) {
        self.createBookUseCase.invoke(book: Book(title: title, author: author)) { [weak self] (bookId: String?, error: RemoteErrors?) in
            if let error = error {
                
            }
            
            if let bookId = bookId {
                self?.shouldDismiss = true
            }
        }
    }
}
