//
//  NotificationController.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/20.
//

import UIKit

class NotificationController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }
}
