//
//  EditProfileViewModel.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/12/29.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .username: return "Username"
        case .fullname: return "Name"
        case .bio: return "Bio"
        }
    }
}

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .username: return user.username
        case .fullname : return user.fullname
        case .bio: return user.bio
        }
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    // bio placeholder의 표시 여부
    var shouldHidePlaceHolderLabel: Bool {
        // bio에 데이터가 없으면 false, 있으면 true 반환
        return user.bio != nil
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}


