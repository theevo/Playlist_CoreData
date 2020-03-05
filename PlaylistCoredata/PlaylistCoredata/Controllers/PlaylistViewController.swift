//
//  PlaylistViewController.swift
//  PlaylistCoredata
//
//  Created by theevo on 3/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var playlistTableView: UITableView!
    
    @IBOutlet weak var playlistNameTextField: UITextField!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistTableView.delegate = self
        playlistTableView.dataSource = self
    }
    
    // MARK: - Action Functions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let playlistName = playlistNameTextField.text else { return }
        if !playlistName.isEmpty && playlistName != "Playlist name" {
            PlaylistController.sharedInstance.createPlaylist(with: playlistName)
            clearPlaylistTextField()
            playlistTableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        if segue.identifier == "toPlaylistDetail" {
            guard let indexPath = playlistTableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? SongsViewController
                else { return }
            let playlistToSend = PlaylistController.sharedInstance.fetchResultsController.object(at: indexPath)
            destinationVC.playlistLandingPad = playlistToSend
        }
    }
    
    // MARK: - Helper Functions
    
    func clearPlaylistTextField() {
        playlistNameTextField.text = ""
    }

}

extension PlaylistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaylistController.sharedInstance.fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlistTableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath)
        let playlist = PlaylistController.sharedInstance.fetchResultsController.object(at: indexPath)
        let songCount = playlist.songs?.count ?? 0
        cell.textLabel?.text = playlist.name
        cell.detailTextLabel?.text = "\(songCount)"
        return cell
    }
}

extension PlaylistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let playlistToDelete = PlaylistController.sharedInstance.fetchResultsController.object(at: indexPath)
            PlaylistController.sharedInstance.deletePlaylist(playlist: playlistToDelete)
            playlistTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
