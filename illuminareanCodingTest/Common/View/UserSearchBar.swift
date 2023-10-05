//
//  UserSearchBar.swift
//  illuminareanTest
//
//  Created by 최제환 on 2023/10/04.
//

import Foundation
import UIKit
import Then
import SnapKit

/**
 - searchBar 참고자료
 https://velog.io/@boms2/Swift-%EA%B2%80%EC%83%89%EC%B0%BDUISearchBar-custom-programmatically-SnapKit-%EC%82%AC%EC%9A%A9
 https://iamcho2.github.io/2021/05/06/customizing-UISearchBar
 */
class UserSearchBar: UIView {
    
    // MARK: UI Component
    
    /// 유저 검색 입력 텍스트 필드
    lazy var textfield = UITextField().then {
        $0.placeholder = "유저 검색"
        $0.returnKeyType = .search
        
        let toolbar = UIToolbar()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(done))
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.sizeToFit()
        toolbar.setItems([flexibleSpaceButton, doneBtn], animated: false)
        $0.inputAccessoryView = toolbar
    }
    
    /// 유저 검색 입력 필드 clear 버튼
    lazy var clearButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        $0.tintColor = .gray
        $0.isHidden = true
    }
    
    /// 유저 검색 버튼
    lazy var searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .black
    }
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: Selector Method
    
    /// textfield toolbar "done"버튼 이벤트
    /// - Parameters:
    /// - Returns:
    @objc
    private func done() {
        endEditing(true)
    }
    
    // MARK: Custom Method
    
    /// UI를 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func configureUI() {
        constraintsTextfield()
        constraintsClearButton()
        constraintsSearchButon()
    }
    
    /// textfield의 제약을 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func constraintsTextfield() {
        addSubview(textfield)
        
        textfield.snp.makeConstraints {
            $0.leading.equalTo(8)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    /// clear button의 제약을 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func constraintsClearButton() {
        addSubview(clearButton)
        
        clearButton.snp.makeConstraints {
            $0.leading.equalTo(textfield.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(33)
        }
    }
    
    /// search button의 제약을 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func constraintsSearchButon() {
        addSubview(searchButton)
        
        searchButton.snp.makeConstraints {
            $0.leading.equalTo(clearButton.snp.trailing).offset(8)
            $0.trailing.equalTo(self.snp.trailing).offset(-8)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(33)
        }
    }
}
