//
//  BookDetailView.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import SwiftUI

struct BookDetailView: View {
    var bookId: String
    @State var shouldPresentSheet: Bool = false
    @ObservedObject private var bookDetailViewModel: BookDetailViewModel
    
    init(bookId: String) {
        self.bookId = bookId
        
        let remoteBooksDataSource: BooksRemoteDataSource = ApolloBooksDataSource()
        let booksRepository: BooksRepository = BooksRepository(remoteBookDataSource: remoteBooksDataSource)
        let getBookUseCase: GetBookUseCase = GetBookUseCase(booksRepository: booksRepository)
        
        self.bookDetailViewModel = BookDetailViewModel(getBookUseCase: getBookUseCase)
        self.bookDetailViewModel.fetchBook(byId: bookId)
    }
    
    var body: some View {
        VStack {
            if !bookDetailViewModel.isFetching {
                if let book = bookDetailViewModel.book {
                    Text(book.title)
                        .font(.headline)
                    Text(book.author)
                } else {
                    
                    Text("No data")
                }
            } else {
                ProgressView()
            }
            
            
        }
        .navigationTitle("Book detail")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    shouldPresentSheet = true
                }) {
                    Label("Edit Item", systemImage: "pencil")
                }
                .sheet(isPresented: $shouldPresentSheet, onDismiss: {
                    withAnimation {
                        bookDetailViewModel.fetchBook(byId: bookId)
                    }
                }) {
                    if let book = bookDetailViewModel.book {
                        EditBookView(book: book)
                    } else {
                        EmptyView()
                    }
                }
                .disabled(bookDetailViewModel.isFetching)
            }
        }
        

        
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(bookId: "633e2eda764db5505df50819")
    }
}
