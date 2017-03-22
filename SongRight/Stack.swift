//
//  Stack.swift
//  SongRight
//
//  Created by Andrew Drechsel on 3/18/17.
//  Copyright © 2017 Andrew Drechsel. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    
    static let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error")
            }
        })
        
        return container
    }()
    
    static var context: NSManagedObjectContext { return container.viewContext }
}
