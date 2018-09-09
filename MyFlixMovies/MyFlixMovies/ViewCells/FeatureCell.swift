//
//  FeatureCell.swift
//  MyFlixMovies
//
//  Created by Ashray P Shetty on 8/20/18.
//  Copyright © 2018 Ashray P Shetty. All rights reserved.
//

import UIKit

// The custom cell to display the top most collection view in home screen.
class FeatureCell: UITableViewCell {

    @IBOutlet weak var UILatestMoviesCollectionView: UICollectionView!
    
    var imageURL = [String!]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension FeatureCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        UILatestMoviesCollectionView.delegate = dataSourceDelegate
        UILatestMoviesCollectionView.dataSource = dataSourceDelegate
        UILatestMoviesCollectionView.tag = row
        UILatestMoviesCollectionView.setContentOffset(UILatestMoviesCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        UILatestMoviesCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { UILatestMoviesCollectionView.contentOffset.x = newValue }
        get { return UILatestMoviesCollectionView.contentOffset.x }
    }
}
