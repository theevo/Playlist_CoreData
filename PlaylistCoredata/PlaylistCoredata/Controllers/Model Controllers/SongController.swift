//
//  SongController.swift
//  Playlist
//
//  Created by James Pacheco on 5/4/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class SongController {
    ///`static` makes to so we can use this function without needing to have in initialized `SongController` class
	static func create(songWithName name: String, artist: String, playlist: Playlist) {
		Song(name: name, artist: artist, playlist: playlist)
        PlaylistController.shared.saveToPersistentStore()
	}
    
    static func delete(song: Song){
        song.managedObjectContext?.delete(song)
        PlaylistController.shared.saveToPersistentStore()
    }
}
 
