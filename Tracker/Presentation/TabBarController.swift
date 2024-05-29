//
//  TabBarController.swift
//  Tracker
//
//  Created by vs on 04.04.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        let trackersVc = UINavigationController(rootViewController: TrackersViewController())
        trackersVc.tabBarItem = UITabBarItem(
            title: L10n.trackers,
            image: .trackers,
            selectedImage: nil
        )
        
        let statisticVc = StatisticViewController()
        statisticVc.tabBarItem = UITabBarItem(
            title: L10n.statistic,
            image: .stats,
            selectedImage: nil
        )
        
        viewControllers = [trackersVc, statisticVc]
        
        tabBar.layer.borderWidth = 0.50
        tabBar.clipsToBounds = true
    }
    
}
