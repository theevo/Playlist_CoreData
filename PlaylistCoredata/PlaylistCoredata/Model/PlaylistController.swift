//
//  PlaylistController.swift
//  PlaylistCoredata
//
//  Created by theevo on 3/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import Foundation
import CoreData

class PlaylistController {
    
    // MARK: - Singleton
    static let sharedInstance = PlaylistController()
    var fetchResultsController: NSFetchedResultsController<Playlist>
    
    // MARK: - Source of truth

    init(){
        let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let resultsController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController = resultsController
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            print("Fetch error. \(error.localizedDescription)\(#function)")
        }
    }
    
    // MARK: - CRUD
    
    func createPlaylist(with name: String) {
        Playlist(name: name)
        saveToPersistentStore()
    }
    
    func deletePlaylist(playlist: Playlist) {
        CoreDataStack.context.delete(playlist)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving to persistent store. \(#function) \(error.localizedDescription)")
        }
        
    }
    
    
} // end class
