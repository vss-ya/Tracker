//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by vs on 14.05.2024.
//

import Foundation

protocol CategoryViewProtocol: AnyObject {
    typealias Binding<T> = (T) -> Void
    
    var categories: [TrackerCategory] { get }
    var selectedCategory: TrackerCategory? { get }
    var selectedCategoryIndex: Int? { get }
    
    var onCategoriesStateChange: Binding<[TrackerCategory]>? { get set }
    var onSelectedCategoryStateChange: Binding<TrackerCategory?>? { get set }
    
    func addCategory(header: String)
    func selectCategory(at index: Int)
    func selectCategory(header: String)
    
}

final class CategoryViewModel: CategoryViewProtocol {
    
    typealias Binding<T> = (T) -> Void
    
    private let notificationCenter = NotificationCenter.default
    private let store = Store.shared
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            onCategoriesStateChange?(categories)
        }
    }
    private(set) var selectedCategory: TrackerCategory? {
        didSet {
            onSelectedCategoryStateChange?(selectedCategory)
        }
    }
    private(set) var selectedCategoryIndex: Int?
    
    var onCategoriesStateChange: Binding<[TrackerCategory]>?
    var onSelectedCategoryStateChange: Binding<TrackerCategory?>?
    
    init() {
        categories = store.trackerCategories
        notificationCenter.addObserver(self,
                                       selector: #selector(storeDidUpdate),
                                       name: .storeDidUpdate,
                                       object: store)
    }
    
    func addCategory(header: String) {
        store.saveCategory(header: header)
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

extension CategoryViewModel {
    
    @objc private func storeDidUpdate() {
        categories = store.trackerCategories
    }
    
}
