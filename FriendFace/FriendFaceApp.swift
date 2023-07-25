//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Hubert Wojtowicz on 25/07/2023.
//

import SwiftUI

@main
struct FriendFaceApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
