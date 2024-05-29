//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by vs on 24.04.2024.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeDidChange(_ store: TrackerCategoryStore) -> Void
}

final class TrackerCategoryStore: NSObject {

    private var context: NSManagedObjectContext
    private lazy var fetchedResultsController = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.header, ascending: true)
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
    var fetchedObjects: [TrackerCategoryCoreData] { fetchedResultsController.fetchedObjects ?? [] }
    weak var delegate: TrackerCategoryStoreDelegate?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func save(_ obj: TrackerCategory) {
        let coreData = TrackerCategoryCoreData(context: context)
        coreData.header = obj.header
        coreData.trackers = obj.trackers.compactMap { $0.id }
        try? context.save()
    }
    
    func addToCategory(withHeader header: String, tracker: UUID) {
        guard let coreData = fetchedObjects.first(where: { $0.header == header }) else {
            assertionFailure("Invalid Configuration")
            return
        }
        let trackers = coreData.trackers ?? []
        guard !trackers.contains(where: { $0 == tracker }) else {
            return
        }
        coreData.trackers = trackers + [tracker]
        try? context.save()
    }
    
    func delete(tracker: UUID) {
        let coreData = fetchedObjects.first(where: {
            ($0.trackers ?? []).contains(where: { $0 == tracker })
        })
        guard let coreData else {
            assertionFailure("Invalid Configuration")
            return
        }
        coreData.trackers = coreData.trackers?.filter({
            $0 != tracker
        })
        try? context.save()
    }
    
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidChange(self)
    }
    
}
