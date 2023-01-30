//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/20.
//

import UIKit
import SDWebImage

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    var user: User? {
        // user 변수에 유저 정보가 할당 된 후 실행되기 때문에 시점때문에 발생하는 문제가 없다.
        didSet { configureLeftBarButton() }
    }
    
    // 해당 유저의 모든 트윗 배열
    private var tweets = [Tweet]() {
        // 트윗을 받아오는 시점보다 CollectionView가 생성되는 시점이 앞서있어 다 받아오면 reload를 해줘야함
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // view가 나타날 때마다 시간 갱신을 하기 위한 reloadData()
        collectionView.reloadData()
    }
    
    // MARK: - Selectors
    
    @objc func handleRefresh() {
        fetchTweets()
    }
    
    @objc func handleProfileImageTap() {
        guard let user = user else { return }
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - API
    
    func fetchTweets() {
        collectionView.refreshControl?.beginRefreshing()
        
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets.sorted(by: { $0.timestamp > $1.timestamp })
            self.checkIfUserLikedTweets()

            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Helpers
    
    func checkIfUserLikedTweets() {
        self.tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                guard didLike == true else { return }
                
                if let index = self.tweets.firstIndex(where: { $0.tweetID == tweet.tweetID }) {
                    self.tweets[index].didLike = true
                }
            }
        }
        
        // enumerated를 사용하여 트윗에 좋아요 여부를 체크!
//        for (index, tweet) in tweets.enumerated() {
//            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
//                guard didLike == true else { return }
//                self.tweets[index].didLike = true
//            }
//        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        // 셀을 collectionView에 등록
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
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
        profileImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        profileImageView.addGestureRecognizer(tap)
        
        // 비동기로 이미지를 가져옴
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

// MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    // 표시할 셀 개수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tweets.count
    }
    
    // 셀에 대한 정보
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 어떤 셀(TweetCell)을 재사용 셀로 사용할건지
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.reuseIdentifier, for: indexPath) as! TweetCell
        
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
//        cell.tweet = tweets.reversed()[indexPath.row] // 최신순 정렬
        
        return cell
    }
    
    // 셀을 클릭했을 때
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // indexPath.row를 사용해 클릭한 트윗의 정보를 넘겨줌.
        let controller = TweetController(tweet: tweets[indexPath.row])
        
//        let controller = TweetController(tweet: tweets.reversed()[indexPath.row]) // 최신순 정렬
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    // 각 셀의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 72)
    }
}

// MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        
        TweetService.shared.likeTweet(tweet: tweet) { err, ref in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            // 트윗을 좋아요 했을 때만 알림을 upload
            /* !tweet.didLike란? -> 알림 구문은 트윗을 좋아요 했을 때만 실행이 되어야한다. 즉, didLike가 true일 때만 실행이 되야한다는 소리인데,
               위에서는 cell의 tweet.didLike 변수를 toggle해준것이지, FeedController의 tweet은 toggle해주지 않았다.
               그러므로 tweet.didLike의 기본값은 false니까 앞에 산술연산자를 붙여 true로 바꾸어준것이다.*/
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(toUser: tweet.user,
                                                          type: .like,
                                                          tweetID: tweet.tweetID)
        }
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

