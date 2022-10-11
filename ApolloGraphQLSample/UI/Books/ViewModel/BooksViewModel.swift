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
        self.getBooksUseCase.invoke { [weak self] result in
            switch result {
            case let .success(books):
                self?.books = books
                break
            case .failure(_):
                self?.alertPresentation = (true, "Error getting books")
                break
            }
        }
    }

    func deleteItems(offsets: IndexSet?) {
        withAnimation {
            guard let offsets = offsets else { return }
            var completed = 0
            for i in offsets {
                self.deleteBookUseCase.invoke(bookId: books[i].id) { [weak self] _ in
                    completed += 1
                    if completed == offsets.count {
                        self?.fetchBooks()
                    }
                }
            }
           
        }
    }
}
