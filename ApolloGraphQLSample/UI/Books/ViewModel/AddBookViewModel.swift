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
        self.createBookUseCase.invoke(book: Book(title: title, author: author)) { [weak self] (result: RemoteResult<String>) in
            switch result {
            case .success(_):
                self?.shouldDismiss = true
                break
            case .failure(_):
                break
            }
            
        }
    }
}
