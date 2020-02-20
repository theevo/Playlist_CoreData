//
//  PlaylistListTableViewController.swift
//  PlaylistCoredata
//
//  Created by Trevor Walker on 2/11/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

class PlaylistListTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var playlistNameTextField: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func addPlaylistButtonTapped(_ sender: Any) {
        guard let playlistName = playlistNameTextField.text, !playlistName.isEmpty else {return}
        PlaylistController.shared.add(playlistWithName: playlistName)
        playlistNameTextField.text = ""
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PlaylistController.shared.playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath)
        
        let playlist = PlaylistController.shared.playlists[indexPath.row]
        let songCount = playlist.songs?.count ?? 0
        
        cell.textLabel?.text = playlist.name
        cell.detailTextLabel?.text = "\(songCount)"
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Grabbing out playlist
            let playlist = PlaylistController.shared.playlists[indexPath.row]
            //Passing our playlist to our delete function
            PlaylistController.shared.delete(playlist: playlist)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let index = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? SongListTableViewController else {return}
            let playlist = PlaylistController.shared.playlists[index.row]
            destinationVC.playlist = playlist
        }
    }
}
