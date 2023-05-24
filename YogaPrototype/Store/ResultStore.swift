//
//  ResultStore.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 11.12.2021.
//

import Foundation
import CoreData
import Combine

class ResultStore<ResultType: SessionResult>: NSObject, NSFetchedResultsControllerDelegate {
    var objectContext: NSManagedObjectContext
    var exercise: Exercise
    
    init(exercise: Exercise, objectContext: NSManagedObjectContext) {
        self.objectContext = objectContext
        self.exercise = exercise
        
        super.init()
    }
    
    var dataRequest: NSFetchRequest<SessionResultData> {
        let request = NSFetchRequest<SessionResultData>(entityName: "SessionResultData")
        request.predicate = NSPredicate(format: "exerciseId == %@", argumentArray: [exercise.uid])
        request.sortDescriptors = [NSSortDescriptor(key: "exerciseId", ascending: true)]
        return request
    }
    
    var objectController: NSFetchedResultsController<SessionResultData>?
    
    private func initializeObjectController() {
        objectController = NSFetchedResultsController<SessionResultData>(fetchRequest: dataRequest,
                                                                       managedObjectContext: objectContext,
                                                                       sectionNameKeyPath: nil,
                                                                       cacheName: nil)

        objectController?.delegate = self
        
        do {
            try objectController?.performFetch()
        } catch {
            print("Could not perform fetch")
        }
    }
    
    lazy var publisher: PassthroughSubject<[ResultType], Never> = {
        [unowned self] in
        initializeObjectController()
        return PassthroughSubject<[ResultType], Never>()
    } ()
    
    private func results(with rawResults: [SessionResultData]) -> [ResultType] {
        var values = [ResultType]()
        for rawResult in rawResults {
            guard
                let content = rawResult.content,
                let json = try? JSONSerialization.jsonObject(with: content, options: []) as? [String: Any],
                let result = ResultType(json: json)
            else {
                continue
            }
            
            values.append(result)
        }
        
        return values.sorted(by: {
            result1, result2 in
            return (result1.timestamp > result2.timestamp)
        })
    }
    
    var results: [ResultType] {
        guard
            let rawValues = try? objectContext.fetch(dataRequest)
        else {
            return []
        }
        
        return results(with: rawValues)
    }
    
    func publishResults() {
        guard
            let rawResults = objectController?.fetchedObjects
        else {
            return
        }
                
        publisher.send(results(with: rawResults))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        publishResults()
    }

    func save(result: ResultType) {
        let json = result.json
        guard
            let content = try? JSONSerialization.data(withJSONObject: json, options: [])
        else {
            return
        }
        
        let storedResult = SessionResultData(context: objectContext)
        storedResult.exerciseId = exercise.uid
        storedResult.content = content
        
        do {
            try objectContext.save()
        } catch {
            
        }
    }
}
