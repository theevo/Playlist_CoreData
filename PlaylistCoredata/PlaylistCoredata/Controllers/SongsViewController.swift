//
//  SongsViewController.swift
//  PlaylistCoredata
//
//  Created by theevo on 3/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

class SongsViewController: UIViewController {
    
    // MARK: - Properties
    
    var playlistLandingPad: Playlist?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var songFieldsTableView: UITableView!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var songTextField: UITextField!
    
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songFieldsTableView.delegate = self
        songFieldsTableView.dataSource = self
    }
    
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let playlist = playlistLandingPad else { return }
        let name = songTextField.text ?? "was there a cereal song?"
        let artist = artistTextField.text ?? "capt. crunch"
        SongController.createSong(title: name, artist: artist, addTo: playlist)
        clearSongFields()
        songFieldsTableView.reloadData()
    }
    
    
    // MARK: - Helper Functions
    
    func clearSongFields() {
        artistTextField.text = ""
        songTextField.text = ""
    }
  
}

extension SongsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let playlist = playlistLandingPad else { return 0 }
        return playlist.songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // fill the cells with data
        
        let cell = songFieldsTableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        guard let playlist = playlistLandingPad else { return UITableViewCell() }
        if let song = playlist.songs?[indexPath.row] as? Song {
            cell.textLabel?.text = song.name
            cell.detailTextLabel?.text = song.artist
        }
        
        
        return cell
    }
    
    
}

extension SongsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let playlist = playlistLandingPad, let songToDelete = playlist.songs?[indexPath.row] as? Song else { return }
            
            SongController.deleteSong(song: songToDelete)
            songFieldsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
