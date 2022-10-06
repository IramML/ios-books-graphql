//
//  BooksListView.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import SwiftUI

struct BooksListView: View {
    @Binding var books: [Book]
    var openItem: (Book) -> Void
    var deleteItems: (IndexSet?) -> Void
    
    var body: some View {
        List {
            ForEach(books) { item in
                NavigationLink {
                    Text(item.title)
                } label: {
                    Text(item.title)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }
}

struct BooksListView_Previews: PreviewProvider {
    private static let book1: Book = Book(title: "Book 1", author: "")
    private static let book2: Book = Book(title: "Book 2", author: "")
    @State private static var books = [book1, book2]
    
    static var previews: some View {
        BooksListView(books: $books) { Book in
            
        } deleteItems: { IndexPath in
            
        }

    }
}
