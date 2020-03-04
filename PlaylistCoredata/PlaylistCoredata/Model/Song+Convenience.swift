//
//  Song+Convenience.swift
//  PlaylistCoredata
//
//  Created by theevo on 3/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import Foundation
import CoreData

extension Song {
    
    convenience init(name: String, artist: String, playlist: Playlist, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.name = name
        self.artist = artist
        self.playlist = playlist
    }
}
