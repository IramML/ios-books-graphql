//
//  EditBookViewModel.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 11/10/22.
//

import Foundation
import Combine

class EditBookViewModel: ObservableObject {
    @Published var isFetching: Bool = false
    
    private let updateBookUseCase: UpdateBookUseCase
    
    var shouldDismiss = PassthroughSubject<Bool, Never>()
    
    init(updateBookUseCase: UpdateBookUseCase) {
        self.updateBookUseCase = updateBookUseCase
    }
    
    func updateBook(byId bookId: String, book newBook: Book) {
        self.updateBookUseCase.invoke(bookId: bookId, book: newBook) { [weak self] (result: RemoteResult<Bool>) in
            switch result {
            case let .success(edited):
                self?.shouldDismiss.send(edited)
            case .failure(_):
                break
            }
        }
    }
}
