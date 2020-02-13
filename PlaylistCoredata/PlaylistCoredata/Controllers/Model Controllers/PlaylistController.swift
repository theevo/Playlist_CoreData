//
//  PlaylistController.swift
//  Playlist
//
//  Created by James Pacheco on 5/4/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CoreData

class PlaylistController {
    
    // MARK: - Properties
    ///Our shared instance
    static let shared = PlaylistController()
    /**This computed property is our source of truth.
     It performs a `NSFetchRequest` then sets what ever it finds to our property. If nothing is found then it returns an empty array
     */
    var playlists: [Playlist] {
        let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    // MARK: - CRUD
    func add(playlistWithName name: String) {
        //Creating a playlist
        Playlist(name: name)
        //
        saveToPersistentStore()
    }
    
    func delete(playlist: Playlist) {
        playlist.managedObjectContext?.delete(playlist)
        saveToPersistentStore()
    }
    
    // MARK: Persistence
    /**
     Saves all changes to coredata
     */
    func saveToPersistentStore() {
        do{
            try CoreDataStack.context.save()
        } catch {
            print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
        }
    }
}
