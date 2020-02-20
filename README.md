# Playlist Coredata - Part 1
## Part 1 - Setting up Core Data
1. In our `xcdatamodel` we need to add our two entities.
	* Playlist
		* Attributes
			* name: String
		* Relationships
			* name: `songs`
			* Destination: `Song`
			* Inverse: `playlist`
	* Song
		* Attributes
			* artist: String
			* name: String
		* Relationships
			* name: `playlist`
			* Destination: `Playlist`		
			* Inverse: `songs`

Make sure the the relationship on `Playlist` is set too `To Many` and that it is ordered. The relationship on `Song` should be set to `To One` be default , but double check just to be sure. You can do all of this on the side bar.

2. Next we will be creating our `CoreDataStack`
	1. Create a new `.swift` file named `CoreDataStack` 
	2. Inside `CoreDataStack.swift`  import `CoreData` allowing us to use the `CoreData` types that we otherwise wouldn’t have access to
	3. Create an `enum` that will complete out `CoreDataStack`
```
enum CoreDataStack {
    ///Creating a static computed property of type `NSPersistentContainer`
    static let container: NSPersistentContainer = {
        //creating our container, note that the name has to be identical to our application name
        let container = NSPersistentContainer(name: “PlaylistCoredata”)
        ///loading our persistant stores completing our core data stack
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error{
                fatalError(“Failed to load Data from persistent Store”)
            }
        })
        return container
    }()
    ///Creating a staic `NSManagedObjectContext` that we can use for our objects context
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}
```

4. Create our `Entity + convenience`
Note: Why are we making a convenience initializer?
	To show this go to the documentation for `NSEntityDescription` and show  all objects need a context
	Wouldn’t it be easier to just create a convenience initializer that allows us to interact with our object how we are used to instead of having to initialize our context every time we want to make a change?
```
extension Song{
    @discardableResult
    convenience init(name: String, artist: String, playlist: Playlist){
        //creating the context that will go along with our object allowing us to use it how we normally would
        self.init(context: CoreDataStack.context)
		  //normal init stuff
        self.name = name
        self.artist = artist
        self.playlist = playlist
    }
}
```

Repeat the process for our song
```
 //This is extending the model that we made in our `xcdatamodeld`.
extension Song {
    @discardableResult
    convenience init(name: String, artist: String, playlist: Playlist){
        //creating the context that will go along with our object allowing us to use it how we normally would
        self.init(context: CoreDataStack.context)
		  //normal init stuff
        self.name = name
        self.artist = artist
        self.playlist = playlist
    }
}
```

## Part 2 - Creating our Controllers
1. Create a new `.swift` file named `PlaylistController` .
	* Create our shared instance
	* Import  `CoreData`
2. Create a function called `saveToPersistance` that will save our changes to `Core Data`
	Note: Be sure to explain why we need this function to save to `Core Data`
```
// MARK: Persistence
///Saves all changes to coredata
func saveToPersistentStore() {
    do{
        try CoreDataStack.context.save()
    } catch {
        print(“There was as error in \(#function) :  \(error) \(error.localizedDescription)”)
    }
}
```
3. Create our Source of Truth
	* Note: Be sure to explain what our fetch request is doing and what a computed property is
```
/**This computed property is our source of truth.
 It performs a `NSFetchRequest` then sets what ever it finds to our property.
If nothing is found then it returns an empty array
 */
var playlists: [Playlist] {
    let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
    return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
}
```

4. Create our crud functions
	* Note: Explain why we don’t need to save our playlist as a variable, and why we call `saveToPersistantStore`
		* Its because we when we initialize our playlist it create the context with it putting it into a holding area in core data
```
// MARK: - CRUD
func add(playlistWithName name: String) {
    //Creating a playlist
    Playlist(name: name)
    saveToPersistentStore()
}
func delete(playlist: Playlist) {
    playlist.managedObjectContext?.delete(playlist)
    saveToPersistentStore()
}
```

5. Create our Song Controller
	* We do not need to import data because we are just going to use the save to persistance that we created on  `SongController`
	* Note: Explain why we are creating `static` functions instead of just `func` and using a `singleton`
```
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
```

## Part 3 - Setting up ViewControllers
Create the following views below

![main.storyboard Screenshot](https://github.com/DevMountain/Playlist_CoreData/blob/fetchRequest/Screen%20Shot%202020-02-13%20at%202.08.59%20PM.png?raw=true)

Note: The two `UITextFields` on the right `TableViewController` are on a `UIView`

### Playlist Table View Controller
1. Create a new `Cocoa Touch Class` called `PlaylistListTableViewController`
	* Remove all functions except for 
	1. `ViewDidLoad()`
	2. `override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int`
	3. `override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell`
	4. `override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:nIndexPath)`
	5. `override func prepare(for segue: UIStoryboardSegue, sender: Any?)`
		
#### Add Playlist Functionality
1. Drag out our an `IBOutlet` for our `playlistNameTextField`
2. Drag out an `IBAction` called `tappedAdd`for our add Button in the upper right hand corner of the screen
3. Inside `tappedAdd`
	* Note: Be sure to explain why we need to safely unwrap our `playlistNameTextField.text` and what `!playlistName.isEmpty` is doing
		* A `!` at the beginning of a boolean flips the value of it
```
guard let playlistName = playlistNameTextField.text, !playlistName.isEmpty else {return}
PlaylistController.shared.add(playlistWithName: playlistName)
playlistNameTextField.text = “”
tableView.reloadData()
```
5. Run the Application and make sure that you can create new playlists
6.  In our `numberOfRowsInSection` return `PlaylistController.shared.playlists.count`
7. In our `cellForRowAt`
		* Note: Don’t forget to set your cells identifier to `playlistCell`
```
let cell = tableView.dequeueReusableCell(withIdentifier: “playlistCell”, for: indexPath)
let playlist = PlaylistController.shared.playlists[indexPath.row]
let songCount = playlist.songs?.count ?? 0
cell.textLabel?.text = playlist.name
cell.detailTextLabel?.text = “\(songCount)”
return cell		
```
8. In our `editingStyle`
```
if editingStyle == .delete {
    //Grabbing out playlist
    let playlist = PlaylistController.shared.playlists[indexPath.row]
    //Passing our playlist to our delete function
    PlaylistController.shared.delete(playlist: playlist)
    tableView.deleteRows(at: [indexPath], with: .fade)
}
```
#### Adding Segue
1. Create a new `UITableViewController` named `SongListTableViewController`
2. Add the property `var playlist: Playlist?`
	* Note: Explain that this is our landing pad, or where our segue is going to send data to.
3. Back on our `PlaylistListTableViewController` In our `prepare(for segue)`
		* Note: Don’t forget to set your segues identifier to `toDetailVC` on `Main.storyboard`
```
// IIDOO
//I - Identifier
if segue.identifier == “toDetailVC” {
// I - Index
    guard let index = tableView.indexPathForSelectedRow,
// D - Destination 
let destinationVC = segue.destination as? SongListTableViewController else {return}
// O - Object to send
    let playlist = PlaylistController.shared.playlists[index.row]
// O - Object to receive
    destinationVC.playlist = playlist
}
```

#### Setting up SongListTableviewController
1. Remove all functions except for 
			1. `ViewDidLoad()`
			2. `override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int`
			3. `override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell`
			4. `override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:nIndexPath)`

2. Drag out our outlets for the two `UITextFields`
```
@IBOutlet weak var artistNameTextField: UITextField!
@IBOutlet weak var trackNameTextField: UITextField!
```
3. Drag out a `IBAction`  and call it `addPlaylistButtonTapped`
```
guard let songName = trackNameTextField.text, let artistName = artistNameTextField.text, let playlist = playlist else {return}
SongController.create(songWithName: songName, artist: artistName, playlist: playlist)
trackNameTextField.text = “”
artistNameTextField.text = “”
tableView.reloadData()
```

#### Set up `UITableView`
1. In our `numberOfRowsInSection`  return `playlist?.songs?.count ?? 0`
	* Note: Explain why we are `nil coalescing`
2. In our `cellForRowAt`
	* Note: Explain why we are unwrapping `playlist` and `song`, along with having to cast `song` to type `Song`
		* Tip: Check what type `unwrappedPlaylist.songs` is
```
let cell = tableView.dequeueReusableCell(withIdentifier: “songCell”, for: indexPath)
guard let unwrappedPlaylist = playlist, let song = unwrappedPlaylist.songs?[indexPath.row] as? Song
else {return UITableViewCell()}
cell.textLabel?.text = song.name
cell.detailTextLabel?.text = song.artist
return cell
```
3. Run app to make sure you can add songs
4. In our `editingStyle`
```
if editingStyle == .delete {
    //Making sure we have a play list, if we do then we grab the song, if not then we return out of the function
    guard let unwrappedPlaylist = playlist, let song = unwrappedPlaylist.songs?[indexPath.row] as? Song else {return}
    
    SongController.delete(song: song)
    tableView.deleteRows(at: [indexPath], with: .fade)
}
```
5. Run app again to make sure we can delete

