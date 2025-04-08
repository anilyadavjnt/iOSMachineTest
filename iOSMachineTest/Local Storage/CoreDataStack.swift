//
//  CoreDataStack.swift
//  iOSMachineTest
//
//  Created by Anil Yadav on 12/03/25.
//  Email: anilyadavjnt@gmail.com
//  Contact No: +91-975211420
//

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack(modelName: "FavouriteUserModel")
    private let modelName: String
    
    lazy var managedContext: NSManagedObjectContext = self.persistentContainer.viewContext
    var favouriteUsers: [FavouriteUser] = []

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    init(modelName: String) {
        self.modelName = modelName
        _ = persistentContainer // This forces the lazy property to initialize
    }

    func saveContext() {
        guard managedContext.hasChanges else {
            print("No changes to save.")
            return
        }
        do {
            try managedContext.save()
            print("Context successfully saved.")
        } catch let error as NSError {
            print("Failed to save context: \(error), \(error.userInfo)")
        }
    }
    
    func fetchFavouriteUsers() -> [FavouriteUser] {
        let request: NSFetchRequest<FavouriteUser> = FavouriteUser.fetchRequest()
        do {
            return try managedContext.fetch(request) // Always fetch fresh data
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }

    func saveUser(user: FavouriteUser) {
        managedContext.insert(user)
        do {
            try managedContext.save()
            favouriteUsers = fetchFavouriteUsers() // Refresh list after saving
        } catch {
            print("Error saving user: \(error)")
        }
    }

    func deleteUser(by id: Int64) {
        let fetchRequest: NSFetchRequest<FavouriteUser> = FavouriteUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))

        do {
            let users = try managedContext.fetch(fetchRequest)
            if let userToDelete = users.first {
                DispatchQueue.main.async { [self] in
                    managedContext.delete(userToDelete)
                    saveContext()
                }
            } else {
                print("User not found!")
            }
        } catch {
            print("Failed to delete user: \(error.localizedDescription)")
        }
    }
        
    func delete(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try persistentContainer.viewContext.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDs = result?.result as? [NSManagedObjectID] ?? []
            let changes = [NSDeletedObjectsKey: objectIDs]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [persistentContainer.viewContext])
        } catch {
            print("Failed to delete entity \(entityName): \(error)")
        }
    }
}



