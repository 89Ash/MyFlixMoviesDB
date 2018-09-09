//
//  MoviesBannerViewController.swift
//  MyFlixMovies
//
//  Created by Ashray P Shetty on 8/23/18.
//  Copyright © 2018 Ashray P Shetty. All rights reserved.
//

import UIKit

// The view controller displayed on clicking "See More" option in Home Screen(ViewController)
class MoviesBannerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var UIMovieBannerCollectionView: UICollectionView!
    
    var imageURL = [String!]()
    
    var movieIds = [String!]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        UIMovieBannerCollectionView.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesListCell", for: indexPath) as! MoviesListCell
        updateMoviePoster(cell: cell, row: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Here, I need 3 equal cells occupying whole screen width so i divided it by 3.0. You can use as per your need.
        return CGSize(width: UIScreen.main.bounds.size.width/3.0, height: 190)
    }
    
    func updateMoviePoster(cell : MoviesListCell,row : Int ){
        if 0 < imageURL.count{
            if(nil != imageURL[row]){
                let url = URL(string: imageURL[row])
                (cell as MoviesListCell).UIMovieBannerImageView.kf.setImage(with: url)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? MoviesListCell
            {
                UIView.transition(with: cell, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: { (finished: Bool) -> () in
                    let movieDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
                    movieDetailsVC.movieId = self.movieIds[indexPath.row]
                    self.navigationController?.pushViewController(movieDetailsVC, animated: true)
                })
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {

      UIView.transition(with: cell, duration: 0.8, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
