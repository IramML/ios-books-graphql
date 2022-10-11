//
//  BookFormView.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 11/10/22.
//

import SwiftUI

struct BookFormView: View {
    @State var title: String = ""
    @State var author: String = ""
    var submit: (Book) -> Void
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .fixedSize(horizontal: false, vertical: false)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            TextField("Author", text: $author)
                .fixedSize(horizontal: false, vertical: false)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
            
            Button {
                submit(Book(title: title, author: author))
            } label: {
                Text("Save")
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
    }
}

struct BookFormView_Previews: PreviewProvider {
    static var previews: some View {
        BookFormView() { _ in
            
        }
    }
}
