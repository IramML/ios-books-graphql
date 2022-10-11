//
//  EditBookView.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 11/10/22.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.presentationMode) var presentationMode
    var book: Book
    @ObservedObject private var editBookViewModel: EditBookViewModel
    
    init(book: Book) {
        self.book = book
        
        let booksRemoteDataSource: BooksRemoteDataSource = ApolloBooksDataSource()
        let booksRepository: BooksRepository = BooksRepository(remoteBookDataSource: booksRemoteDataSource)
        let updateBookUseCase: UpdateBookUseCase = UpdateBookUseCase(booksRepository: booksRepository)
        self.editBookViewModel = EditBookViewModel(updateBookUseCase: updateBookUseCase)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                BookFormView(title: book.title, author: book.author) { newBook in
                    self.editBookViewModel.updateBook(byId: book.id, book: newBook)
                }
                Spacer()
            }
        }
        .onReceive(editBookViewModel.shouldDismiss) { shouldDismiss in
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct EditBookView_Previews: PreviewProvider {
    static var previews: some View {
        EditBookView(book: Book(title: "Sample title", author: "Sample author"))
    }
}
