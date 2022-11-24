//
//  User.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/24.
//

import Foundation

// 유저 모델
struct User {
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: URL?
    let uid: String
    
    // dictionary를 파라미터로 받음으로써 더 편리하게 초기화가 가능하다.
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}
