//
//  ExerciStore.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 09.12.2021.
//

import Foundation
import CoreData
import Combine

class ExerciseStore: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    @Published var items = [Exercise]()
    
    var objectContext: NSManagedObjectContext
    
    private var exerciseDataController: NSFetchedResultsController<ExerciseData>
    
    private func updateItems() {
        guard
            let results = exerciseDataController.fetchedObjects
        else {
            return
        }
        
        var tmpItems = [Exercise]()
        for result in results {
            guard
                let item = Exercise(data: result)
            else {
                continue
            }
            
            if let rawMeta = result.meta,
               let metaJSON = try? JSONSerialization.jsonObject(with: rawMeta, options: []) as? [Any] {
                for metaItem in metaJSON {
                    guard
                        let dict = metaItem as? [String: Any],
                        let meta = parse(metadataJSON: dict)
                    else {
                        continue
                    }
                    
                    item.metadata.append(meta)
                }
            }
            
            tmpItems.append(item)
        }
        
        items = tmpItems
    }
    
    init(objectContext: NSManagedObjectContext) {
        self.objectContext = objectContext
        
        let request = NSFetchRequest<ExerciseData>(entityName: "ExerciseData")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ExerciseData.name, ascending: true)]
        
        exerciseDataController = NSFetchedResultsController<ExerciseData>(
            fetchRequest: request,
            managedObjectContext: objectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        super.init()
        
        exerciseDataController.delegate = self
        
        do {
            try exerciseDataController.performFetch()
            updateItems()
        } catch let err {
            print(err)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateItems()
    }
        
    func parse(metadataJSON: [String: Any]) -> Any? {
        guard
            let rawType = metadataJSON[Keys.type] as? Int,
            let type = MetadataType(rawValue: rawType),
            let valueDict = metadataJSON[Keys.value] as? [String: Any]
        else {
            return nil
        }
        
        switch (type) {
        case .holderPose:
            return HolderMetadata(json: valueDict)
        case .repeaterPose:
            return RepeaterMetadata(json: valueDict)
        }
    }
    
    class Keys {
        private init() {}
        
        static let type = "type"
        static let value = "value"
    }
}
