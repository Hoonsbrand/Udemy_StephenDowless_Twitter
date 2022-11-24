//
//  AuthService.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/22.
//

import UIKit
import Firebase

// 구조체를 따로 만들어 파라미터로 넘겨주면 코드가 더 간결해진다. (조원들이랑 이외의 장점을 말해보기)
struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.password
        let username = credentials.password
        
        // 파일 압축
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        // 파일 id 생성
        let filename = NSUUID().uuidString
        
        // 하단에서 values를 실제 데이터베이스에 넣을 때 바로 Constants를 이용하는 것보다 변수에 담아서 사용하는게 좋다고 했다.
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { meta, error in
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                // Firebase에 등록
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    
                    // uid 가져오기
                    guard let uid = result?.user.uid else { return }
                    
                    // values 딕서녀리 안에 담기
                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullname,
                                  "profileImageUrl": profileImageUrl]
                    
                    // 데이터를 담은 values를 실제 데이터베이스에 넣기
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
