# Playlist Coredata - Converting FetchRequest to FetchResult
1. Remove the source of truth on the `PlaylistController`
2. Create a a property called `fetchedResultsController` of  type `NSFetchedResultsController<Playlist>`
`var fetchedResultsController: NSFetchedResultsController<Playlist>`
3. Create an initializer that Initializes an instance of the PlaylistController class to interact with Playlist objects using the singleton pattern
    * Note: Be sure to explain the code and walk through it with the students
```
init() {
    //creates request
    let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
    // Add the Sort Descriptors to the request. Sort Descriptors allows us to determine how we want the data organized from the fetch request
    request.sortDescriptors = [NSSortDescriptor(key: “name”, ascending: true)]
    // Initialize a NSfetchedResultsController using the Fetch Request we just created
    let resultsController: NSFetchedResultsController<Playlist> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    // Set the initized NSFRC to our property
    fetchedResultsController = resultsController
    do{ // do/catch will display an error if fetchedResultsController isn't working
        try fetchedResultsController.performFetch()
    } catch {
        print("There was an error performing the fetch. \(error.localizedDescription)")
    }
}
```
4. On our `PlaylistListTableviewController` return `PlaylistController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0` from `numberOfRowsInSection`
    * Note: Explain how the fetchResults is working
5. In our `cellForRowAt`  let our `playlist` equal `PlaylistController.shared.fetchedResultsController.object(at: indexPath)`
6. In our segue let our `playlist` equal `PlaylistController.shared.fetchedResultsController.object(at: index)`
