//
//  ContentView.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 03/10/22.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @State var items: [Book] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text(item.title)
                    } label: {
                        Text(item.title)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
