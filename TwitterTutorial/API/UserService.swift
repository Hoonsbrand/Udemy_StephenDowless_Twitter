//
//  UserService.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/22.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            print("DEBUG: snapshot is \(snapshot)")
            // dictionary 형태로 snapshot 추출
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            // 사용자에 대한 정보를 사용할 때 dictionary 에서 바로 사용하는 것보다 구조체를 만들어 할당하는 것이 더 좋다.
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}
