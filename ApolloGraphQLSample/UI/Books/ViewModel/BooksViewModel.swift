//
//  BooksViewModel.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import Foundation
import SwiftUI

class BooksViewModel: ObservableObject {
    private let getBooksUseCase: GetBooksUseCase
    private let deleteBookUseCase: DeleteBookUseCase
    @Published var books: [Book] = []
    @Published var alertPresentation: (shouldPresent: Bool, title: String) = (false, "")
    
    init(getBooksUseCase: GetBooksUseCase, deleteBookUseCase: DeleteBookUseCase) {
        self.getBooksUseCase = getBooksUseCase
        self.deleteBookUseCase = deleteBookUseCase
        self.fetchBooks()
    }
    
    func fetchBooks() {
        self.getBooksUseCase.invoke { [weak self] (books: [Book]?, error: RemoteErrors?) in
            if error != nil {
                self?.alertPresentation = (true, "Error getting books")
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
                self.deleteBookUseCase.invoke(bookId: books[i].id) { [weak self] (deleted: Bool?, error: RemoteErrors?) in
                    completed += 1
                    if error != nil && offsets.count == 1 {
                        self?.alertPresentation = (true, "Error deleting book")
                    }
                    
                    if completed == offsets.count {
                        self?.fetchBooks()
                    }
                }
            }
           
        }
    }
}
