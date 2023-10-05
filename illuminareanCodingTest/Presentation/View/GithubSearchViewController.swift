//
//  GithubSearchViewController.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/4/23.
//

import UIKit
import Combine
import Kingfisher

/**
 - UICollectionViewDiffableDataSource 참고자료
  https://zeddios.tistory.com/1197
  https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views
  https://velog.io/@bsm4045/Swift-UICollectionView-Diffable-Datasource-Compositional-Layout
 */
class GithubSearchViewController: UIViewController {
    
    // MARK: - UI Components
    
    /// 유저 검색 필드
    lazy var userSearchBar = UserSearchBar().then {
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 10
        $0.searchButton.addTarget(self, action: #selector(didTappedSearch), for: .touchUpInside)
        $0.clearButton.addTarget(self, action: #selector(didTappedClear), for: .touchUpInside)
        $0.textfield.delegate = self
    }
    
    /// 검색된 결과를 보여주는 collectionView
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.delegate = self
    }

    // MARK: - Property
    typealias Item = SearchUser
    
    enum Section: Int {
        case list
        case empty
    }
    
    var viewModel: GithubSearchViewModel!
    var cancellables = Set<AnyCancellable>()
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        viewModel.requestCode()
        
        
        bind()
    }
    
    // MARK: Selector Method
    
    /// 검색 입력 필드 검색 이벤트
    /// - Parameters:
    /// - Returns:
    @objc
    func didTappedSearch() {
        view.endEditing(true)
        
        if viewModel.keyword.isEmpty {
            showAlertWithOneAction("유저 검색", "검색할 유저를 입력하세요", "확인") { [weak self] _ in
                guard let self else { return }
                
                self.userSearchBar.textfield.becomeFirstResponder()
            }
        } else {
            viewModel.getUser()
        }
    }
    
    /// 검색 입력 필드 Clear 이벤트
    /// - Parameters:
    /// - Returns:
    @objc
    func didTappedClear() {
        userSearchBar.textfield.text = ""
        userSearchBar.clearButton.isHidden = true
        viewModel.keyword = ""
    }

    // MARK: Custom Method
    
    /// UI를 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        constraintsUserSearchBar()
        constratintsCollectionView()
        configureCollectionView()
    }
    
    /// UserSearchBar의 제약을 설정하는 메서드
    /// - Parameters:
    /// - Returns:
    private func constraintsUserSearchBar() {
        view.addSubview(userSearchBar)
        
        userSearchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.height.equalTo(60)
        }
    }
    
    /// CollectionView의 제약을 설정하는 메서드
    /// - Parameters:
    /// - Returns:
    private func constratintsCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(userSearchBar.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    /// collectionview를 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "UserCell", bundle: .main), forCellWithReuseIdentifier: UserCell.identifier)
        collectionView.register(UINib(nibName: "EmptyCell", bundle: .main), forCellWithReuseIdentifier: EmptyCell.identifier)
        
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            
            switch section {
            case .list:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.identifier, for: indexPath) as? UserCell else { return UICollectionViewCell() }
                
                cell.configure(item)

                return cell
            case .empty:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.identifier, for: indexPath) as? EmptyCell else { return UICollectionViewCell() }

                return cell
            }
            
        })
        
        
        collectionView.collectionViewLayout = layout()
    }
    
    /// collectionview의 layout을 구성하는 메서드
    /// - Parameters:
    /// - Returns:
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: viewModel.searchUsers.count > 0 ? .absolute(80) : .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: viewModel.searchUsers.count > 0 ? .absolute(80) : .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    /// 데이터 바인딩을 하는 메서드
    /// - Parameters:
    /// - Returns:
    private func bind() {
        viewModel.$searchUsers
            .receive(on: RunLoop.main)
            .sink { [weak self] users in
                guard let self else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                snapshot.appendSections([.list, .empty])
                
                if users.count > 0 {
                    snapshot.appendItems(users, toSection: .list)
                } else {
                    snapshot.appendItems([SearchUser(id: -1, login: "", avatarUrl: "", htmlUrl: "")], toSection: .empty)
                }
                
                self.datasource.apply(snapshot)
                
                self.collectionView.collectionViewLayout = self.layout()
            }.store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                guard let self else { return }
                
                if !errorMessage.isEmpty {
                    self.showAlertWithOneAction("네트워크 통신", errorMessage, "확인", nil)
                }
            }.store(in: &cancellables)
    }
    
    /// 하나의 Action을 가지는 Alert을 생성하는 메서드
    /// - Parameters:
    ///   - title: 팝업 타이틀
    ///   - message: 팝업 메세지
    ///   - buttonTitle: 팝업 버튼 타이틀
    ///   - handler: 팝업 버튼 액션
    /// - Returns:
    private func showAlertWithOneAction(_ title: String, _ message: String, _ buttonTitle: String, _ handler: ((UIAlertAction) -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        
        alertVC.addAction(alertAction)
        
        present(alertVC, animated: true)
    }
}

// MARK: UICollectionViewDelegate
extension GithubSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: viewModel.searchUsers[indexPath.item].htmlUrl) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.searchUsers.count - 5 {
            if viewModel.searchUsers.count < viewModel.totalCount {
                viewModel.currentPage += 1
                viewModel.getUser()
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension GithubSearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            viewModel.keyword = text
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            userSearchBar.clearButton.isHidden = false
        } else {
            userSearchBar.clearButton.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            viewModel.keyword = text
        }
        
        if viewModel.keyword.isEmpty {
            showAlertWithOneAction("유저 검색", "검색할 유저를 입력하세요", "확인") { [weak self] _ in
                guard let self else { return }
                
                self.userSearchBar.textfield.becomeFirstResponder()
            }
        } else {
            view.endEditing(true)
            viewModel.getUser()
        }
        
        return true
    }
}
