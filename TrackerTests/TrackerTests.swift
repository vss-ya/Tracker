//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by vs on 28.05.2024.
//

import XCTest
import SnapshotTesting

@testable import Tracker

final class TrackerTests: XCTestCase {

    private var vc: TrackersViewController!
    
    override func setUp() {
        super.setUp()
        vc = .init()
    }
    
    override func tearDown() {
        vc = nil
        super.tearDown()
    }
    
    func testLightTheme() throws {
        let nav = UINavigationController(rootViewController: vc)
        assertSnapshot(
            matching: nav,
            as: .image(traits: .init(userInterfaceStyle: .light))
        )
    }
    
    func testDarkTheme() throws {
        let nav = UINavigationController(rootViewController: vc)
        assertSnapshot(
            matching: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark))
        )
    }

}
