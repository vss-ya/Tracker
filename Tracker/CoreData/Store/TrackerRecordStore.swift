//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by vs on 24.04.2024.
//

import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func storeDidChange(_ store: TrackerRecordStore) -> Void
}

final class TrackerRecordStore: NSObject {
    
    private var context: NSManagedObjectContext
    private lazy var fetchedResultsController = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? controller.performFetch()
        return controller
    }()
    
    var trackerRecords: [TrackerRecord] { fetchTrackerRecords() }
    weak var delegate: TrackerRecordStoreDelegate?
    
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.init()
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func save(_ obj: TrackerRecord) {
        let coreData = TrackerRecordCoreData(context: context)
        coreData.id = obj.id
        coreData.date = obj.date
        try? context.save()
    }
    
    func delete(_ obj: TrackerRecord) {
        guard let coreData = fetch(for: obj) else {
            return
        }
        context.delete(coreData)
        try? context.save()
    }
    
    private func trackerRecord(from coredData: TrackerRecordCoreData) -> TrackerRecord? {
        guard
            let id = coredData.id,
            let date = coredData.date else 
        {
            return nil
        }
        return TrackerRecord(id: id, date: date)
    }
    
    private func fetch(for obj: TrackerRecord) -> TrackerRecordCoreData? {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", obj.id as CVarArg)
        let result = try? context.fetch(fetchRequest)
        return result?.first
    }
    
    private func fetchTrackerRecords() -> [TrackerRecord] {
        guard let objects = fetchedResultsController.fetchedObjects else {
            return []
        }
        let result = objects.compactMap({ trackerRecord(from: $0) })
        return result
    }
    
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidChange(self)
    }
    
}
