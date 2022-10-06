//
//  Book.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 04/10/22.
//

import Foundation

struct Book: Identifiable {
    let id: String
    var title: String
    var author: String
    
    init(id: String, title: String, author: String) {
        self.id = id
        self.title = title
        self.author = author
    }
    
    init(title: String, author: String) {
        self.id = UUID().uuidString
        self.title = title
        self.author = author
    }
}
