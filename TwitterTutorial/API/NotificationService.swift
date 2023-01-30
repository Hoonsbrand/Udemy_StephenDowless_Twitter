//
//  NotificationService.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/12/14.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
//    func uploadNotification(type: NotificationType, tweet: Tweet? = nil, user: User? = nil) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        /* uid를 사용하지만 Notification 객체에 변수로써 넣지 않은 이유?
//           Notification에서는 이미 User를 생성자에서 받고있다.
//           그 User를 이용해서 snapshot에 접근한 다음 uid를 받아오면 되기 때문이다. (TweetService에서도 같은 방식으로 사용함)*/
//
//        // values를 var로 선언한 이유는 하단의 코드는 공통적인 내용만을 작성한것으로, 어떤 타입이냐에 따라 알림의 내용은 추후에 따로 세팅해줘야 하기 때문
//        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
//                                     "uid": uid,
//                                     "type": type.rawValue]
//
//        // 알림의 타입에 따라 values의 내용도 변경된다.
//        // ex) 팔로우 알림이면 좋아요에 관한 알림이 아니기 때문에 어떤 트윗을 좋아했는지에 대한 내용이 없다는 등...
//        if let tweet = tweet {
//            values["tweetID"] = tweet.tweetID
//            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
//
//            // 팔로우 관련
//        } else if let user = user {
//            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
//        }
//    }
    
    func uploadNotification(toUser user: User, type: NotificationType, tweetID: String? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        if let tweetID = tweetID {
            values["tweetID"] = tweetID
        }
        
        REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
    }
    
    private func getNotifications(uid: String, completion: @escaping ([Notification]) -> Void) {
        var notifications = [Notification]()

        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            print("DEBUG: Did enter completion block..")
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
    
    func fetchNotification(completion: @escaping([Notification]) -> Void) {
        let notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        /// 알림이 있는지 확인
        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            // 해당 유저에 대한 알림이 없을 때
            if !snapshot.exists() {
                completion(notifications)
            } else {
                // 알림이 있을 때
                self.getNotifications(uid: uid, completion: completion)
            }
        }
    }
}



