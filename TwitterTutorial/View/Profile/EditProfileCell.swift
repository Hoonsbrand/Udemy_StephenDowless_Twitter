//
//  EditProfileCell.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/12/29.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: EditProfileViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: EditProfileCellDelegate?
    
    /// fullname, username, bio 세가지 항목 이름
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    /// 각 항목에 채워넣는 TextField
    lazy var infoTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .twitterBlue
        // TextField의 editing이 끝나면 자동으로 handleUpdateUserInfo를 호출해준다.
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        tf.text = "Test user Attribute"
        
        return tf
    }()
    
    let bioTextView: InputTextView = {
        let tv = InputTextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .twitterBlue
        tv.placeholderLabel.text = "Bio"
        
        return tv
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 16)
        
        contentView.addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor,
                             right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
        
        contentView.addSubview(bioTextView)
        bioTextView.anchor(top: topAnchor, left: titleLabel.rightAnchor,
                           bottom: bottomAnchor, right: rightAnchor,
                           paddingTop: 4, paddingLeft: 13, paddingRight: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo),
                                               name: UITextView.textDidEndEditingNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) { 
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }

        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView

        titleLabel.text = viewModel.titleText

        infoTextField.text = viewModel.optionValue
        
        bioTextView.placeholderLabel.isHidden = viewModel.shouldHidePlaceHolderLabel
        bioTextView.text = viewModel.optionValue
    }
}

extension EditProfileCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}



