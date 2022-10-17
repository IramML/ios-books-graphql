//
//  AddBookView.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var title: String = ""
    @State var author: String = ""
    
    @ObservedObject private var addBookViewModel: AddBookViewModel
    
    init() {
        let booksRemoteDataSource: BooksRemoteDataSource = BooksRequester()
        
        let booksRepository: BooksRepository = BooksRepository(remoteBookDataSource: booksRemoteDataSource)
        
        let addBookUseCase: CreateBookUseCase = CreateBookUseCase(booksRepository: booksRepository)
        
        self.addBookViewModel = AddBookViewModel(createBookUseCase: addBookUseCase)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                BookFormView() { (book: Book) in
                    addBookViewModel.addBook(title: book.title, author: book.author)
                }
                Spacer()
                
            }
        }
        .onReceive(addBookViewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
