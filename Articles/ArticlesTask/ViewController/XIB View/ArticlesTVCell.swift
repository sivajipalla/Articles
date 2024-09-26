//
//  ArticlesTVCell.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import UIKit

class ArticlesTVCell: UITableViewCell {

    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var articleTitleLbl: UILabel!
    @IBOutlet weak var articleDescriptionLbl: UILabel!
    @IBOutlet weak var articlePublishedDateLbl: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    var article: Article? {
        didSet {
            guard let article = article, let pubDate = article.mediumPublishedDate else { return }
            articleTitleLbl.text = article.headline?.main ?? ""
            articlePublishedDateLbl.text = "\(pubDate)"
            articleDescriptionLbl?.text = article.abstract ?? ""

            if let multimediaURL = article.multimedia?.first?.url {
                let fullURL = "https://www.nytimes.com/\(multimediaURL)" // Assuming URL needs base path
                
                ImageCacheManager.shared.loadImage(from: fullURL) { [weak self] image in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.articleImg.image = image ?? UIImage(named: "placeholder")
                    }
                }
            } else {
                articleImg.image = UIImage(named: "placeholder")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        articleImg.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImg.image = nil  // Reset image when reusing cells
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
