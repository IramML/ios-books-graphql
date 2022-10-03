//
//  ApolloGraphQLSampleApp.swift
//  ApolloGraphQLSample
//
//  Created by Iram Martinez on 03/10/22.
//

import SwiftUI

@main
struct ApolloGraphQLSampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
