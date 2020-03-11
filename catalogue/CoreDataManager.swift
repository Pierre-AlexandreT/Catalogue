//
//  CoreDataManager.swift
//  catalogue
//
//  Created by lpiem on 11/03/2020.
//  Copyright © 2020 pat. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
    }
    
    init() {
        createRandomItems()
    }
    //MARK: - Items Manager
    
    func createRandomItems(){
        
        if let items = loadItems(ascend: false){
            if(items.count == 0){
                let randomData = ["Veste", "Chaussure", "Pantalon", "Slip", "Chaussette"]
                
                for name in randomData {
                    let _ = createItemWithName(name, price: Double(round(100*Double.random(in: 1..<100))/100))
                }
                
                saveContext()
            }
        }
        
        
    }
    
    func createItemWithName(_ name: String, price: Double) -> Item {
        let item = Item(context: context)
        item.name = name
        item.price = price
        return item
    }
    
    func updateItems(item: Item){
        
    }
    
    
    func loadItems(ascend: Bool, name: String? = nil, price: Double? = nil)-> [Item]?{
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: ascend)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let searchTerm = name, name != "" {
            let predicate = NSPredicate(format: "name contains[cd] %@", searchTerm)
            fetchRequest.predicate = predicate
        }
        
        if let maxPrice = price {
            let predicate = NSPredicate(format: "name <= %@", maxPrice)
            fetchRequest.predicate = predicate
        }
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    func getMaxPriceItem()-> [Item]?{
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "price", ascending: true)
        var result: [Item] = []
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            result = try context.fetch(fetchRequest)
        } catch {
            return nil
        }
        
        if (result.count != 0){
            return [result[0], result[result.count-1]]
        }else{
            return nil
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "catalogue")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
