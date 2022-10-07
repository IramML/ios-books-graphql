//
//  AddBookView.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var title: String = ""
    @State var author: String = ""
    
    @ObservedObject private var addBookViewModel: AddBookViewModel
    
    init() {
        let booksRemoteDataSource: BooksRemoteDataSource = ApolloBooksDataSource()
        
        let booksRepository: BooksRepository = BooksRepository(remoteBookDataSource: booksRemoteDataSource)
        
        let addBookUseCase: CreateBookUseCase = CreateBookUseCase(booksRepository: booksRepository)
        
        addBookViewModel = AddBookViewModel(createBookUseCase: addBookUseCase)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                TextField("Title", text: $title)
                    .fixedSize(horizontal: false, vertical: false)
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                TextField("Author", text: $author)
                    .fixedSize(horizontal: false, vertical: false)
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
                
                Button {
                    addBookViewModel.addBook(title: title, author: author)
                } label: {
                    Text("Save")
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                Spacer()
                
                if addBookViewModel.shouldDismiss && dismiss() {
                   EmptyView()
                }
            }
        }
    }
    
    func dismiss() -> Bool {
        presentationMode.wrappedValue.dismiss()
        return true
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
