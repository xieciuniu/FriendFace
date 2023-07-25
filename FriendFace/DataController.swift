//
//  DataController.swift
//  FriendFace
//
//  Created by Hubert Wojtowicz on 25/07/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FriendFace")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.overwrite
        }
    }
}
