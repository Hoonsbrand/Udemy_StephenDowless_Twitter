//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/20.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    
    // MARK: - Properties
    
    var user: User? {
        // user 변수에 유저 정보가 할당 된 후 실행되기 때문에 시점때문에 발생하는 문제가 없다.
        didSet { configureLeftBarButton() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
    }
    
    // configureUI()는 viewDidLoad에서 호출하고 있기 때문에 FeedController가 메모리에 로드되자마자 호출된다.
    // 그러므로 유저의 프로필 이미지를 이 메서드에서 작업할 수 없다. (시점이 더 빠르기 때문)
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        // 프로필 이미지 뷰 생성
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        // 비동기로 이미지를 가져옴
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
