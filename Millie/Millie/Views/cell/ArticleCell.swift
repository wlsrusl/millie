//
//  ArticleCell.swift
//  Millie
//
//  Created by JG on 2024/05/23.
//

import UIKit
import Kingfisher

class ArticleCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with article: LocalArticle) {
        titleLabel.text = article.title
        dateLabel.text = article.publishedAt
        let url = URL(string: article.urlToImage ?? "")
        imageView.kf.setImage(with: url)
        titleLabel.textColor = article.isRead ? .red : .black
    }
}
