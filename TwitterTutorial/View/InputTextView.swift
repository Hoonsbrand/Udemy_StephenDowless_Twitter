//
//  CaptionTextView.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/24.
//

import UIKit

// 코드의 간결함을 위해서 UploadTweetController에 모두 때려박는 것보다는 따로 하위의 클래스를 만드는게 좋다.
class InputTextView: UITextView {
    
    // MARK: - Properties
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happening?"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // view.을 안붙이는 이유? -> 이 UITextView 클래스는 이미 UIView의 직속 하위 클래스이기 때문이다.
        // ViewController에서는 실제 뷰 구성 요소에 엑세스를 먼저 하고 속성을 설정해줘야 한다.
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange),
                                               name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
