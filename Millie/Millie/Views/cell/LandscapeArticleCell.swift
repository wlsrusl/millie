//
//  LandscapeArticleCell.swift
//  Millie
//
//  Created by JG on 2024/05/25.
//

import UIKit

class LandscapeArticleCell: UICollectionViewCell {
    // MARK: - Properties
    let cellIdentifier = "ArticleCell"
    var collectionView: UICollectionView!
    var navigationController: UINavigationController?

    var articles: [LocalArticle] = [] {
        didSet {
            collectionView.reloadData() // articles가 변경될 때 컬렉션 뷰를 리로드
        }
    }
    var viewModel: NewsViewModel?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    // MARK: - Setup

    // 초기화 시 컬렉션 뷰 설정
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 스크롤 방향을 가로로 설정
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.register(UINib(nibName:cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier) // 셀 등록
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false // 수평 스크롤 표시줄 숨김
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with articles: [LocalArticle], navigation: UINavigationController?, viewModel: NewsViewModel) {
        self.articles = articles
        self.navigationController = navigation
        self.viewModel = viewModel
    }
}

extension LandscapeArticleCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count // 섹션당 아이템 수
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ArticleCell
        let article = articles[indexPath.item]
        cell.configure(with: article) // 셀 설정
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UIDevice.current.orientation.isLandscape {
            let article = articles[indexPath.item]
            viewModel?.markArticleAsRead(article)

            let webViewController = WebViewController()
            webViewController.urlString = article.url
            navigationController?.pushViewController(webViewController, animated: true) // 선택한 셀의 기사 URL을 웹뷰로 표시
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 아이템 사이즈
        return CGSize(width: 300, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // 아이템 간 간격
    }
}
