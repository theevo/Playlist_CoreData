//
//  CoreDataStack.swift
//  PlaylistNSUserDefaults
//
//  Created by DevMountain on 9/5/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    ///Creating a global computed property of type `NSPersistentContainer`
    static let container: NSPersistentContainer = {
        //creating our container, note that the name has to be identical to our application name
        let container = NSPersistentContainer(name: "PlaylistCoredata")
        ///loading our persistant stores completing our core data stack
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error{
                fatalError("Failed to load Data from persistent Store")
            }
        })
        return container
    }()
    ///Creating a global `NSManagedObjectContext`
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}
