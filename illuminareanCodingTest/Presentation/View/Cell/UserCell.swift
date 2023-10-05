//
//  UserCell.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/5/23.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class UserCell: UICollectionViewCell {

    // MARK: UI Components
    
    /// 사용자 thumbnail Image
    lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    /// 사용자 이름
    lazy var nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        $0.textColor = .black
    }
    
    /// 사용자 repo url 주소
    lazy var repoUrlLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .gray
    }
    
    // MARK: Property
    
    static let identifier = "UserCell"
    
    // MARK: View Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    // MARK: Custom Method
    
    /// UI를 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func configureUI() {
        constraintsThumbnailImageView()
        constraintsNameLabel()
        constraintsRepoUrlLabel()
    }
    
    /// thumbnail ImageView의 제약을 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func constraintsThumbnailImageView() {
        contentView.addSubview(thumbnailImageView)
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
    }
    
    /// name label의 제약을 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func constraintsNameLabel() {
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(16)
        }
    }
    
    /// repourl label의 제약을 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func constraintsRepoUrlLabel() {
        contentView.addSubview(repoUrlLabel)
        
        repoUrlLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
    }
    
    /// 검색된 유저정보를 cell에 구성하는 메서드
    /// - Parameters:
    ///   - searchUser: 검색된 유저정보
    /// - Returns:
    func configure(_ searchUser: SearchUser) {
        thumbnailImageView.kf.setImage(with: URL(string: searchUser.avatarUrl))
        nameLabel.text = searchUser.login
        repoUrlLabel.text = searchUser.htmlUrl
    }
}
