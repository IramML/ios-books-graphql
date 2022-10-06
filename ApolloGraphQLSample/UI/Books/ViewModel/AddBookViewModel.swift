//
//  AddBookViewModel.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import Foundation
import SwiftUI

class AddBookViewModel: ObservableObject {
    @Published var shouldDismiss: Bool = false
    
    func addBook(title: String, author: String) {
        Network.shared.createBook(book: Book(title: title, author: author)) { [weak self] (bookId: String?, error: ApolloErrors?) in
            if let error = error {
                
            }
            
            if let bookId = bookId {
                self?.shouldDismiss = true
            }
        }
    }
}
