//
//  CategoryCell.swift
//  MyFlixMovies
//
//  Created by Ashray P Shetty on 8/20/18.
//  Copyright © 2018 Ashray P Shetty. All rights reserved.
//

import UIKit

// The custom cell to display the Now playing, Popular, Top rated and upcoming movies.
class CategoryCell: UITableViewCell {

    @IBOutlet weak var UICategoryLabel: UILabel!
    @IBAction func SeeMore(_ sender: Any) {
        tappedSeeMoreButton?(self)
    }
   
    @IBOutlet weak var UIImageMovie1: UIImageView!
    @IBOutlet weak var UIImageMovie2: UIImageView!
    @IBOutlet weak var UIImageMovie3: UIImageView!
    
    var tappedSeeMoreButton : ((CategoryCell) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
