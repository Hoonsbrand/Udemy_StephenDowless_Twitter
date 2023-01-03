//
//  Constants.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/22.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

// MARK: - 기본 reference
let DB_REF = Database.database().reference()

// MARK: - 유저관련 reference
let REF_USERS = DB_REF.child("users")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_USER_USERNAMES = DB_REF.child("user-usernames")

// MARK: - 트윗관련 reference
let REF_TWEETS = DB_REF.child("tweets")
let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")
let REF_TWEET_LIKES = DB_REF.child("tweet-likes")
let REF_USER_REPLIES = DB_REF.child("user-replies")

// MARK: - 알림관련 reference
let REF_NOTIFICATIONS = DB_REF.child("notification")
