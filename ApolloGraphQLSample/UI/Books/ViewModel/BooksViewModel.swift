//
//  BooksViewModel.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import Foundation
import SwiftUI

class BooksViewModel: ObservableObject {
    @Published var books: [Book] = []
    
    init() {
        self.fetchBooks()
    }
    
    func fetchBooks() {
        Network.shared.fetchBooks { [weak self] (books: [Book]?, error: ApolloErrors?) in
            if let error = error {
                
            }
            
            if let books = books {
                self?.books = books
            }
        }
    }

    func deleteItems(offsets: IndexSet?) {
        withAnimation {
            guard let offsets = offsets else { return }
            var completed = 0
            for i in offsets {
                Network.shared.deleteBook(bookId: books[i].id) { [weak self] (deleted: Bool?, error: ApolloErrors?) in
                    completed += 1
                    if let error = error {
                        
                    }
                    
                    if completed == offsets.count {
                        self?.fetchBooks()
                    }
                }
            }
           
        }
    }
}
