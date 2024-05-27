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
            title: "Trackers".localized(),
            image: UIImage(named: "Trackers"),
            selectedImage: nil
        )
        
        let statisticVc = StatisticViewController()
        statisticVc.tabBarItem = UITabBarItem(
            title: "Stats".localized(),
            image: UIImage(named: "Stats"),
            selectedImage: nil
        )
        
        viewControllers = [trackersVc, statisticVc]
        
        tabBar.layer.borderWidth = 0.50
        tabBar.clipsToBounds = true
    }
    
}
