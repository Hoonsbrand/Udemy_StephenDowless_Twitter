//
//  ProfileHeaderViewModel.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/27.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var bioString: String {
        return user.bio ?? ""
    }
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var actionButtonTitle: String {
        // 자신의 프로필을 보고있을 때
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        // 데이터를 받아오기 전에는 "Loading"
//        guard let isFollowed = user.isFollowed else { return "Loading" }
        
        // 데이터를 받아온 후에는 "Following" or "Follow"
        return user.isFollowed ? "Follwoing" : "Follow"
    }
    
    init(user: User) {
        self.user = user
        
        self.usernameText = "@" + user.username
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value) ",
                                                        attributes: [.font:
                                                                    UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text) ", attributes: [.font :
                                                                                    UIFont.systemFont(ofSize: 14),
                                                                                    .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
