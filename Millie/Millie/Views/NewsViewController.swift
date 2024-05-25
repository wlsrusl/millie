//
//  NewsViewController.swift
//  Millie
//
//  Created by JG on 2024/05/23.
//

import UIKit

class NewsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var cellIdentifier = "ArticleCell"
    private var landscapeCellIdentifier = "LandscapeArticleCell"
    private let viewModel = NewsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView() // 컬렉션 뷰 설정
        fetchArticles() // 기사 데이터 가져오기

        // 기기 방향 변화 감지
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName:cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier) // 세로 모드 셀 등록
        collectionView.register(UINib(nibName:landscapeCellIdentifier, bundle: nil), forCellWithReuseIdentifier: landscapeCellIdentifier) // 가로 모드 셀 등록
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func fetchArticles() {
        viewModel.fetchArticles {
            DispatchQueue.main.async {
                self.collectionView.reloadData() // 기사 데이터를 가져온 후 리로드
            }
        }
    }

    @objc private func deviceOrientationDidChange() {
        collectionView.collectionViewLayout.invalidateLayout() // 레이아웃 무효화
        collectionView.reloadData() // 데이터 리로드
    }
}

extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UIDevice.current.orientation.isLandscape {
            return Int(ceil(Double(viewModel.articles.count) / 5.0)) // 가로 모드에서는 한 셀에 5개 기사
        } else {
            return viewModel.articles.count // 세로 모드에서는 모든 기사 표시
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if UIDevice.current.orientation.isLandscape {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: landscapeCellIdentifier, for: indexPath) as! LandscapeArticleCell
            let startItemIdx = min(indexPath.item * 5, viewModel.articles.count - 5)
            let endItemIdx = min(startItemIdx + 4, viewModel.articles.count - 1)
            let articles = Array(viewModel.articles[startItemIdx...endItemIdx])
            cell.configure(with: articles, navigation: navigationController, viewModel: viewModel) // 가로 모드 셀 설정
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ArticleCell
            let article = viewModel.articles[indexPath.item]
            cell.configure(with: article) // 세로 모드 셀 설정
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !UIDevice.current.orientation.isLandscape {
            let article = viewModel.articles[indexPath.item]
            viewModel.markArticleAsRead(article)

            let webViewController = WebViewController()
            webViewController.urlString = article.url
            navigationController?.pushViewController(webViewController, animated: true) // 웹뷰 컨트롤러로 이동
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: view.bounds.width, height: 120) // 가로 모드 셀 크기
        } else {
            return CGSize(width: view.bounds.width, height: 400) // 세로 모드 셀 크기
        }
    }
}
