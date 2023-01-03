//
//  ProfileFilterCell.swift
//  TwitterTutorial
//
//  Created by hoonsbrand on 2022/11/27.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var option: ProfileFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "Test filter"
        return label
    }()
    
    // 선택이 되었을 때를 자동으로 감지하여 그에 따른 반응을 할 수 있다.
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ReusableView

extension ProfileFilterCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
