//
//  Store.swift
//  Tracker
//
//  Created by vs on 30.05.2024.
//

import Foundation
import UIKit
import CoreData

extension Notification.Name {
    
    static let storeDidUpdate = Notification.Name("storeDidUpdateNotification")
    
}

final class Store {
    
    static let shared = Store()
    
    private let notificationCenter = NotificationCenter.default
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerStore: TrackerStore
    private let trackerRecordStore: TrackerRecordStore
    
    var trackers: [Tracker] { fetchTrackers() }
    var trackerRecords: [TrackerRecord] { fetchTrackerRecords() }
    var trackerCategories: [TrackerCategory] { fetchCategories() }
    
    static func register() {
        let _ = shared
    }
    
    private init() {
        persistentContainer = {
            let container = NSPersistentContainer(name: "TrackersCoreData")
            container.loadPersistentStores { (storeDescription, error) in
                if let error = error as? NSError {
                    assertionFailure("Unresolved error \(error), \(error.userInfo)")
                    return
                }
                guard let url = storeDescription.url?.absoluteString else {
                    return
                }
                print("Store url - \(url)")
            }
            return container
        }()
        context = persistentContainer.viewContext
        
        trackerCategoryStore = TrackerCategoryStore(context: context)
        trackerStore = TrackerStore(context: context)
        trackerRecordStore = TrackerRecordStore(context: context)
        
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        trackerCategoryStore.delegate = self
    }
    
}

// MARK: - Tracker Categories
extension Store {
    
    private func fetchCategories() -> [TrackerCategory] {
        trackerCategoryStore.fetchedObjects.compactMap({
            trackerCategory(from: $0)
        })
    }
    
    private func trackerCategory(from coreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard
            let header = coreData.header,
            let trackerIds = coreData.trackers
        else {
            return nil
        }
        let result = TrackerCategory(
            header: header,
            trackers: trackers.filter { tracker in
                trackerIds.contains(where: { id in
                    tracker.id == id
                })
            }
        )
        return result
    }
    
}

// MARK: - Trackers
extension Store {
    
    private func fetchTrackers() -> [Tracker] {
        trackerStore.fetchedObjects.compactMap({
            tracker(from: $0)
        })
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
    
}

// MARK: - Tracker Records
extension Store {
    
    private func fetchTrackerRecords() -> [TrackerRecord] {
        trackerRecordStore.fetchedObjects.compactMap({
            trackerRecord(from: $0)
        })
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
    
}

extension Store {
    
    func saveCategory(header: String) {
        trackerCategoryStore.save(TrackerCategory(header: header, trackers: []))
    }
    
    func save(tracker: Tracker, category: TrackerCategory) {
        trackerStore.save(tracker)
        trackerCategoryStore.addToCategory(withHeader: category.header, tracker: tracker.id)
    }
    
    func update(tracker: Tracker, category: TrackerCategory) {
        trackerStore.delete(id: tracker.id)
        trackerCategoryStore.delete(tracker: tracker.id)
        trackerStore.save(tracker)
        trackerCategoryStore.addToCategory(withHeader: category.header, tracker: tracker.id)
    }
    
    func delete(tracker: Tracker) {
        trackerStore.delete(id: tracker.id)
        trackerRecordStore.delete(id: tracker.id)
        trackerCategoryStore.delete(tracker: tracker.id)
    }
    
    func pin(tracker: Tracker, _ pinned: Bool) {
        trackerStore.pin(id: tracker.id, pinned)
    }
    
    func save(record: TrackerRecord) {
        trackerRecordStore.save(record)
    }
    
    func delete(record: TrackerRecord) {
        trackerRecordStore.delete(record)
    }
    
}

extension Store: TrackerStoreDelegate {
    
    func storeDidChange(_ store: TrackerStore) {
        notificationCenter.post(name: .storeDidUpdate, object: self)
    }
    
}

extension Store: TrackerRecordStoreDelegate {
    
    func storeDidChange(_ store: TrackerRecordStore) {
        notificationCenter.post(name: .storeDidUpdate, object: self)
    }
    
}

extension Store: TrackerCategoryStoreDelegate {
    
    func storeDidChange(_ store: TrackerCategoryStore) {
        notificationCenter.post(name: .storeDidUpdate, object: self)
    }
    
}
