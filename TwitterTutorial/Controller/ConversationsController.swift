//
//  ConversationsController.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/20.
//

import UIKit

class ConversationsController: UIViewController {
    
    // MARK: - Properties
    
    var contentModeImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = #imageLiteral(resourceName: "ex")
        
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        self.view.addSubview(contentModeImage)
        contentModeImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
     
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}


