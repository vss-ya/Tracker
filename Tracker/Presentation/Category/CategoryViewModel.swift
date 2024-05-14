//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by vs on 14.05.2024.
//

import CoreData

final class CategoryViewModel {
    
    typealias Binding<T> = (T) -> Void
    
    private var categoryStore = TrackerCategoryStore()
    
    private (set) var categories: [TrackerCategory] = [] {
        didSet {
            onCategoriesStateChange?(categories)
        }
    }
    private (set) var selectedCategory: TrackerCategory? {
        didSet {
            onSelectedCategoryStateChange?(selectedCategory)
        }
    }
    private (set) var selectedCategoryIndex: Int?
    
    var onCategoriesStateChange: Binding<[TrackerCategory]>?
    var onSelectedCategoryStateChange: Binding<TrackerCategory?>?
    
    init() {
        categoryStore.delegate = self
        categories = categoryStore.trackerCategories
    }
    
    func addCategory(header: String) {
        categoryStore.save(TrackerCategory(header: header, trackers: []))
    }
    
    func addTrackerToCategory(withHeader header: String, tracker: Tracker) {
        categoryStore.addToCategory(withHeader: header, tracker: tracker)
    }
    
    func selectCategory(at index: Int) {
        guard categories.count > 0, 0..<categories.count ~= index else {
            selectedCategoryIndex = nil
            selectedCategory = nil
            return
        }
        selectedCategoryIndex = index
        selectedCategory = categories[index]
    }
    
    func selectCategory(header: String) {
        let index = categories.firstIndex(where: { $0.header == header })
        selectCategory(at: index ?? -1)
    }
    
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    
    func storeDidChange(_ store: TrackerCategoryStore) {
        categories = store.trackerCategories
    }
    
}
