//
//  PostTableViewCell.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 08/05/2026.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    static let nibName = "PostTableViewCell"
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonFav: UIButton!
    
    private var post: Post! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with post: Post) {
        self.post = post
        labelTitle.text = "#\(post.id) - \(post.title)"
        labelDescription.text = post.body
        buttonFav.isUserInteractionEnabled = false
        setIsFavourite(value: post.isFavorite)
        self.layoutIfNeeded()
    }
    
    private func setIsFavourite(value: Bool) {
        let imageName = value ? "heart.fill" : "heart"
        buttonFav.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction func buttonFavTapped(_ sender: Any) {
        
    }
    
}
