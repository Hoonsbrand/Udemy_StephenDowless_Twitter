//
//  UserService.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/22.
//

import Firebase

// 지속적으로 사용하는 Completion을 typealias를 통해 커스텀 타입으로 만들어 줌.
typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            // dictionary 형태로 snapshot 추출
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            // 사용자에 대한 정보를 사용할 때 dictionary 에서 바로 사용하는 것보다 구조체를 만들어 할당하는 것이 더 좋다.
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        // completion으로 전달해 줄 user 목록 배열
        var users = [User]()
        
        // firebase에 접근해 user 목록의 snapshot을 가져옴
        REF_USERS.observe(.childAdded) { snapshot in
            // snapshot의 key인 uid와 value인 유저 정보를 각 변수에 할당
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            // User객체 생성 -> users 배열에 추가 -> completion으로 전달
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { err, ref in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { err, ref in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            print("DEBUG: User is followed is \(snapshot.exists())")
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            // snapshot의 모든 자식 수를 센다.
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping(URL?) -> Void) {
        // UIImage -> jpeg 변환
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // uuidString으로 파일 이름 생성
        let filename = NSUUID().uuidString
        // firebase Storage에 해당 filename child 생성
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        // firebase Storage - filename에 이미지 데이터 넣기
        ref.putData(imageData, metadata: nil) { meta, err in
            // 이미지 URL 다운로드
            ref.downloadURL { url, err in
                // absoluteString을 이용해 절대주소를 profileImageUrl에 할당.
                // 절대주소란? 간단히 말하면 NSURL이 http://aaa.com 의 /doc/sample.txt 라는 문서를 가리키고 있으면
                // http://aaa.com/doc/sample.txt를 돌려주는 것이 이 두 가지 함수가 하는 일이다.
                guard let profileImageUrl = url?.absoluteString else { return }
                
                // 담겨진 주소를 dictionary로 values에 할당
                let values = ["profileImageUrl": profileImageUrl]
                // 이미지 주소가 담긴 values를 firebase에 업데이트
                REF_USERS.child(uid).updateChildValues(values) { err, ref in
                    completion(url)
                }
            }
        }
    }
    
    func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["fullname": user.fullname,
                      "username": user.username,
                      "bio": user.bio ?? ""]
        
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchUser(withUsername username: String, completion: @escaping(User) -> Void) {
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else { return }
            self.fetchUser(uid: uid, completion: completion)
        }
    }
}



