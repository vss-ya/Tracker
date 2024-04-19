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
    private let trackerStore = TrackerStore()
    
    var trackerCategories: [TrackerCategory] { fetchTrackerCategories() }
    weak var delegate: TrackerCategoryStoreDelegate?
    
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
    
    func save(_ obj: TrackerCategory) {
        let coreData = TrackerCategoryCoreData(context: context)
        coreData.header = obj.header
        coreData.trackers = obj.trackers.compactMap {
            let cd = TrackerCoreData(context: context)
            cd.id = $0.id
            return cd
        }
        try? context.save()
    }
    
    func addrToCategory(with header: String, tracker: Tracker) {
        guard let coreData = fetch(with: header) else {
            fatalError()
        }
        coreData.trackers = trackerCategories.first {
            $0.header == header
        }?.trackers.compactMap {
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = $0.id
            return trackerCoreData
        }
        try? context.save()
    }
    
    private func trackerCategory(from coreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard
            let header = coreData.header,
            let trackers = coreData.trackers
        else {
            return nil
        }
        let result = TrackerCategory(
            header: header,
            trackers: trackerStore.trackers.filter { tracker in
                trackers.contains(where: {
                    tracker.id == $0.id
                })
            }
        )
        return result
    }
    
    private func fetch(with header: String) -> TrackerCategoryCoreData? {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "header == %@", header as CVarArg)
        let result = try? context.fetch(fetchRequest)
        return result?.first
    }
    
    private func fetchTrackerCategories() -> [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else {
            return []
        }
        let result = objects.compactMap({ trackerCategory(from: $0) })
        return result
    }
    
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidChange(self)
    }
    
}
