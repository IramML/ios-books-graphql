//
//  BookDetailView.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 05/10/22.
//

import SwiftUI

struct BookDetailView: View {
    var book: Book
    
    var body: some View {
        
        Text(book.title)
            .navigationBarTitle("Book detail")
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: Book(title: "Title", author: "Author"))
    }
}
