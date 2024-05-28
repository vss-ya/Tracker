//
//  TrackerStore.swift
//  Tracker
//
//  Created by vs on 24.04.2024.
//

import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func storeDidChange(_ store: TrackerStore) -> Void
}

final class TrackerStore: NSObject {
    
    private var context: NSManagedObjectContext
    private lazy var fetchedResultsController = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
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
    
    var trackers: [Tracker] { fetchTrackers() }
    weak var delegate: TrackerStoreDelegate?
    
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
        self.fetchedResultsController.delegate = self
    }
    
    func save(_ obj: Tracker) {
        let coreData = trackerCoreData(from: obj)
        try? context.save()
    }
    
    func pin(_ obj: Tracker, _ pinned: Bool) {
        let coreData = fetchedResultsController.fetchedObjects?.first(where: { $0.id == obj.id })
        coreData?.pinned = pinned
        try? context.save()
    }
    
    private func fetchTrackers() -> [Tracker] {
        guard let objects = fetchedResultsController.fetchedObjects else {
            return []
        }
        let result = objects.compactMap({ tracker(from: $0) })
        return result
    }
    
    private func tracker(from coreData: TrackerCoreData) -> Tracker? {
        guard let id = coreData.id,
              let emoji = coreData.emoji,
              let color = coreData.color,
              let title = coreData.title,
              let schedule = coreData.schedule
        else {
            return nil
        }
        let pinned = coreData.pinned
        return Tracker(id: id,
                       title: title,
                       color: UIColor(hex: color),
                       emoji: emoji,
                       schedule: schedule.compactMap({ WeekDay(rawValue: $0)}),
                       pinned: pinned)
    }
    
    private func trackerCoreData(from obj: Tracker) -> TrackerCoreData {
        let coreData = TrackerCoreData(context: context)
        coreData.id = obj.id
        coreData.title = obj.title
        coreData.color = obj.color.toHexString()
        coreData.emoji = obj.emoji
        coreData.schedule = obj.schedule?.map {
            $0.rawValue
        }
        coreData.pinned = obj.pinned
        return coreData
    }
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidChange(self)
    }
    
}
