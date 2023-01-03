//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/20.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    // 접근한 user를 위한 변수 할당
    var user: User? {
        // didSet은 해당 user가 설정되면 실행된다.
        didSet {
            // viewControllers는 UITabBarController의 변수이다. 탭바는 여러개의 뷰컨으로 이루어져있기 때문에 서브스크립트로 접근이 가능하다. (feed는 0번)
            guard let nav = viewControllers?[0] as? UINavigationController else { return } // ❓ UINav로 캐스팅을 하는 이유? ❓
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            // feed의 user에 할당
            feed.user = user
        }
    }
    
    // 코드로 UI를 만들기
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    // MARK: - API
    
    // 유저 정보 가져오기
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // completion을 사용하여 user에 직접적으로 접근이 가능해진다.
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user // user 변수에 할당
        }
    }
    
    // 사용자가 로그인 했는지 체크
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            print("DEBUG: Did log user out..")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                
                // 로그인이 안되어있으면 로그인 창을 fullScreen으로 띄움
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            // 로그인이 되어있으면 피드를 보여줌
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonTapped() {
        guard let user = user else { return }
        let controller = UploadTweetController(user: user, config: .tweet)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        
        // 만약 완벽한 원형을 만들고 싶다면, 우선 높이와 넓이가 같아야하고 그 값을 2로 나누면 된다.
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers() {
        
//        특정 VC를 nav라는 이름으로 불러왔으나, 해당 VC의 user라는 저장 프로퍼티에 접근할 수 없다.
//        왜냐하면, 현재 선택된 nav라는 이름의 VC는 UINavigationController타입이기 때문에,
//        as?키워드를 통해 내가 접근할 VC로 형변환 시켜주어야한다.
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationViewController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationViewController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notifications = NotificationController()
        let nav3 = templateNavigationViewController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationViewController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationViewController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white.withAlphaComponent(0.5)
        
        return nav
    }
}


/*
 TintColor?

 우선 TintColor가 무엇인지 알아보겠습니다. TintColor는 시각적으로 화면 상의 어떤 요소가 현재 활성화되었는지를 보여주는 요소입니다. 예를 들어 NavigationBar의 아이템의 Refresh 버튼이나 Back 버튼을 누르면 단순히 눌리기만 하는 것이 아니라 눌렀을 때는 흰색으로 변했다가 때면 다시 원래의 색으로 돌아오는 것을 확인하실 수 있습니다. 이런 효과를 가능케 하는 것이 바로 TintColor입니다.
  
 기본적으로 TintColor는 UIView의 프로퍼티로 존재합니다. 그렇기 때문에 UIView를 상속받는 뷰들은 다음과 같이 TintColor를 적용시킬 수 있습니다.
 
 트위터 프로젝트에서는 받아온 아이콘을 이미지로 사용하는데 프로젝트 전체적인 색에 맞추어 아이콘의 색도 바꿔주어야 할 때 사용했다.
 */
