//
//  AddBookViewModel.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import Foundation
import Combine

class AddBookViewModel: ObservableObject {
    private let createBookUseCase: CreateBookUseCase
    var shouldDismiss = PassthroughSubject<Bool, Never>()
    
    init(createBookUseCase: CreateBookUseCase) {
        self.createBookUseCase = createBookUseCase
    }
    
    func addBook(title: String, author: String) {
        self.createBookUseCase.invoke(book: Book(title: title, author: author)) { [weak self] (result: RemoteResult<String>) in
            switch result {
            case .success(_):
                self?.shouldDismiss.send(true)
            case .failure(_):
                break
            }
            
        }
    }
}
