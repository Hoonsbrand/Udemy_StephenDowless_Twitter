//
//  Utilities.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/21.
//

import UIKit

class Utilities {
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iv.image = image
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                  paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)

        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                           right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        // NSMutableAttributedString: 문자열 특정 부분 색 바꿔주고 싶을 때
        // NSMutableAttributedString을 사용하면 굉장히 편리하게 하나의 레이블 내에서 색이나 폰트, 크기 등의 속성을 변경할 수 있다.
        // 원래는 서로 다른 속성을 가진 레이블 두개를 따로 따로 만들어줘야함.
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes:
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
             NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes:
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
             NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}
