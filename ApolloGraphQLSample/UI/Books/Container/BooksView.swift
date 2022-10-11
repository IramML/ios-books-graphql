//
//  ContentView.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 03/10/22.
//

import SwiftUI
import CoreData

struct BooksView: View {
    @State private var shouldPresentSheet: Bool = false
    @State private var shouldPresent: Bool = false
    @State private var bookToPresent: Book? = nil
    @ObservedObject var booksViewModel: BooksViewModel
    
    init() {
        let booksRemoteDataSource: BooksRemoteDataSource = ApolloBooksDataSource()
        
        let booksRepository: BooksRepository = BooksRepository(remoteBookDataSource: booksRemoteDataSource)
        
        let getBooksUseCase: GetBooksUseCase = GetBooksUseCase(booksRepository: booksRepository)
        let deleteBookUseCase: DeleteBookUseCase = DeleteBookUseCase(booksRepository: booksRepository)
        
        booksViewModel = BooksViewModel(getBooksUseCase: getBooksUseCase, deleteBookUseCase: deleteBookUseCase)
    }

    var body: some View {
         
        NavigationStack {
            ZStack {
                if !booksViewModel.isFetching {
                    if booksViewModel.books.count > 0 {
                        BooksListView(books: $booksViewModel.books, openItem: { book in
                            bookToPresent = book
                            shouldPresent = true
                        }, deleteItems: booksViewModel.deleteItems)
                    } else {
                        Text("No books")
                    }
                    
                } else {
                    ProgressView()
                }
                
            }
            .navigationDestination(isPresented: $shouldPresent) {
                if shouldPresent, let book = bookToPresent {
                    BookDetailView(bookId: book.id)
                }
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        shouldPresentSheet = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .sheet(isPresented: $shouldPresentSheet, onDismiss: {
                        withAnimation {
                            booksViewModel.fetchBooks()
                        }
                    }) {
                        AddBookView()
                    }
                    
                }
            }
            
        }
        
        
            
        
    }

}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView()
    }
}
