//
//  ContentView.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 03/10/22.
//

import SwiftUI
import CoreData

enum BooksRouter {
    case add, detail(book: Book)
}

struct BooksView: View {
    @State private var shouldPresentSheet: Bool = false
    @State private var shouldPresent: Bool = false
    @State private var routeToPreset: BooksRouter? = nil
    @ObservedObject var booksViewModel = BooksViewModel()

    var body: some View {
        NavigationView {
            NavigationStack {
                ZStack {
                    BooksListView(books: $booksViewModel.books, openItem: { book in
                        routeToPreset = .detail(book: book)
                        shouldPresent = true
                    }, deleteItems: booksViewModel.deleteItems)
                }
                .navigationBarTitle("Books")
                .navigationDestination(isPresented: $shouldPresent) {
                    if let routeToPreset = routeToPreset {
                        switch routeToPreset {
                        case .add:
                            EmptyView()
                        case let .detail(book):
                            BookDetailView(book: book)
                        }
                    }
                   
                }
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
        
        .navigationViewStyle(.stack)
        
    }

}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView()
    }
}
