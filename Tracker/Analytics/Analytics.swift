//
//  Analytics.swift
//  Tracker
//
//  Created by vs on 29.05.2024.
//

import Foundation
import YandexMobileMetrica

final class Analytics {
    
    enum Screen: String {
        case main = "Main"
    }
    
    enum Event: String {
        case open
        case close
        case click
    }
    
    enum Item: String {
        case addTrack = "add_track"
        case track
        case filter
        case edit
        case delete
    }
    
    enum Key: String {
        case screen
        case event
        case item
    }
    
    static let shared = Analytics()
    
    private init() { }
    
    func report(_ event: Event, params : [Key : Any]) {
        let params = params.reduce(into: [String: Any]()) { partialResult, kv in
            partialResult[kv.key.rawValue] = kv.value
        }
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
    
    func open(screen: Screen) {
        report(.open, params: [.screen: screen.rawValue])
    }
    
    func close(screen: Screen) {
        report(.close, params: [.screen: screen.rawValue])
    }
    
    func click(screen: Screen, item: Item) {
        report(.click, params: [.screen: screen.rawValue, .item: item.rawValue])
    }
    
}
