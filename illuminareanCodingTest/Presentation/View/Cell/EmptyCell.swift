//
//  EmptyCell.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/5/23.
//

import UIKit
import Then
import SnapKit

class EmptyCell: UICollectionViewCell {
    
    // MARK: UI Component
    
    /// 검색된 유저가 없을 때 문구
    lazy var emptyLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .lightGray
        $0.text = "검색된 유저가 없습니다"
        $0.textAlignment = .center
    }
    
    // MARK: Property
    
    static let identifier = "EmptyCell"

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
        constraintsEmptyLabel()
    }

    /// empty label의 제약을 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func constraintsEmptyLabel() {
        addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading)
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing)
        }
    }
}
