//
//  ViewController.swift
//  MyFlixMovies
//
//  Created by Ashray P Shetty on 8/20/18.
//  Copyright © 2018 Ashray P Shetty. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration

// The View Controller representing the initial view controller (Home page) of app.
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var UIMoviesTableView: UITableView!
    
    var storedOffsets = [Int: CGFloat]()
    
    let movieService : MovieService = MovieService()
    
    var latestimageURL = [String!]()
    var imageURL = [String!]()
    var popularMovieImageURL = [String!]()
    var topRatedMovieImageURL = [String!]()
    var upcomingMovieImageURL = [String!]()
    
    var latestmovieIds = [String!]()
    var movieIds = [String!]()
    var popularmovieIds = [String!]()
    var topRatedmovieIds = [String!]()
    var upComingmovieIds = [String!]()
    
    var latestMovierefreshCount : Int  = 0
    var nowPlayingMovierefreshCount : Int  = 0
    var popularMovierefreshCount : Int  = 0
    var topMovierefreshCount : Int  = 0
    var upcomingMovierefreshCount : Int  = 0
    
    var requestInProgress : Bool = false
    var latestRefreshRequest : Bool  = true
    var nowPlayingRefreshRequest : Bool  = true
    var popularRefreshRequest : Bool  = true
    var topRefreshRequest : Bool  = true
    var upcomingRefreshRequest : Bool  = true
    
    var utilities = Utilities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        if(isActiveNetworkConnectionAvailable()){
            if(imageURL.count > 0 && imageURL[imageURL.count - 1] != nil){
                utilities.stopActivityIndicator()
            }else{
                utilities.startActivityIndicator(view: self.view)
            }
        }
        CheckInternetConnectivity()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Latest, Now playing, Popular, Top rated and Upcoming.
        // Total 5 rows in the table view.
        return 5
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell") as! FeatureCell
        
        storedOffsets[indexPath.row] = cell.collectionViewOffset
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        // If the current row is the first row then populate the feature cell with the big movie image.
        if row==0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell") as! FeatureCell
            cell.imageURL = self.imageURL
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
            return cell
        }
            // Otherwise populate the category cell. i.e. the cell having the category label, see more and movie images
        else
        {
            let cell : CategoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
            initializeCategoryLabels(row: row, cell: cell)
            
            let moviesBannerVC = self.storyboard?.instantiateViewController(withIdentifier: "MoviesBannerViewController") as! MoviesBannerViewController
            
            switch row{
            case 1:
                moviesBannerVC.imageURL = self.imageURL
                moviesBannerVC.movieIds = self.movieIds
                break
            case 2:
                moviesBannerVC.imageURL = self.popularMovieImageURL
                moviesBannerVC.movieIds = self.popularmovieIds
                break
            case 3:
                moviesBannerVC.imageURL = self.topRatedMovieImageURL
                moviesBannerVC.movieIds = self.topRatedmovieIds
                break
            case 4:
                moviesBannerVC.imageURL = self.upcomingMovieImageURL
                moviesBannerVC.movieIds = self.upComingmovieIds
                break
            default:
                moviesBannerVC.imageURL = self.imageURL
                moviesBannerVC.movieIds = self.movieIds
                break
            }
            
            cell.tappedSeeMoreButton = {
                [unowned self] (selectedCell) -> Void in
                self.navigationController?.pushViewController(moviesBannerVC, animated: true)
            }
            return cell
        }
    }
    
    // Method to fetch the list of movies
    func FetchAllMoviesFromServer(){
        
            movieService.getLatestMovie{ [weak self] (jsonData: JSON) in
                self?.onReceiveLatestMovies(data: jsonData)
            }
            
            movieService.getNowPlayingMovies{ [weak self] (jsonData: JSON) in
                self?.onReceiveNowPlayingMovies(data: jsonData)
            }
            
            movieService.getPopularMovies{ [weak self] (jsonData: JSON) in
                self?.onReceivePopularMovies(data: jsonData)
            }
            
            movieService.getTopRatedMovies{ [weak self] (jsonData: JSON) in
                self?.onReceiveTopRatedMovies(data: jsonData)
            }
            
            movieService.getUpcomingMovies{ [weak self] (jsonData: JSON) in
                self?.onReceiveUpcomingMovies(data: jsonData)
            }
        requestInProgress = true
    }
    
    // Tapped Gesture for ImageViews
    @objc func imageViewTapped(sender : ImageTapGesture){
        let movieDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        var movieId : String = ""
        switch sender.row {
        case 1:
            if movieIds.count > 0 && nil != movieIds[sender.index]{
                movieId = movieIds[sender.index]
            }
            break;
        case 2:
            if popularmovieIds.count > 0 && nil != popularmovieIds[sender.index]{
                movieId = popularmovieIds[sender.index]
            }
            break;
        case 3:
            if topRatedmovieIds.count > 0 && nil != topRatedmovieIds[sender.index]{
                movieId = topRatedmovieIds[sender.index]
            }
            break;
        case 4:
            if upComingmovieIds.count > 0 && nil != upComingmovieIds[sender.index]{
                movieId = upComingmovieIds[sender.index]
            }
            break;
        default:
            if movieIds.count > 0 && nil != movieIds[sender.index]{
                movieId = movieIds[sender.index]
            }
            break
        }
        
        if !movieId.isEmpty{
            movieDetailsVC.movieId = movieId
            self.navigationController?.pushViewController(movieDetailsVC, animated: true)
        }
    }
    
    // On Launch update the section labels to indicate the movie type.
    func initializeCategoryLabels(row : Int, cell : UITableViewCell){
        let image1GestureRecognizer = ImageTapGesture(target: self, action: #selector(self.imageViewTapped(sender:)))
        image1GestureRecognizer.cell = (cell as! CategoryCell)
        image1GestureRecognizer.row = row
        image1GestureRecognizer.index = 0
        
        let image2GestureRecognizer = ImageTapGesture(target: self, action: #selector(self.imageViewTapped(sender:)))
        image2GestureRecognizer.cell = (cell as! CategoryCell)
        image2GestureRecognizer.row = row
        image2GestureRecognizer.index = 1
        
        let image3GestureRecognizer = ImageTapGesture(target: self, action: #selector(self.imageViewTapped(sender:)))
        image3GestureRecognizer.cell = (cell as! CategoryCell)
        image3GestureRecognizer.row = row
        image3GestureRecognizer.index = 2
        
        (cell as! CategoryCell).UIImageMovie1.addGestureRecognizer(image1GestureRecognizer)
        (cell as! CategoryCell).UIImageMovie2.addGestureRecognizer(image2GestureRecognizer)
        (cell as! CategoryCell).UIImageMovie3.addGestureRecognizer(image3GestureRecognizer)
        
        switch row {
        case 0:
            break
        case 1:
            (cell as! CategoryCell).UICategoryLabel.text! = "Now Playing"
            updateCategoryCellImages(count: imageURL.count, cell: cell as! CategoryCell, urls: imageURL)
            break
        case 2:
            (cell as! CategoryCell).UICategoryLabel.text = "Popular"
            updateCategoryCellImages(count: popularMovieImageURL.count, cell: cell as! CategoryCell, urls: popularMovieImageURL)
            break
        case 3:
            (cell as! CategoryCell).UICategoryLabel.text = "Top Rated"
            updateCategoryCellImages(count: topRatedMovieImageURL.count, cell: cell as! CategoryCell, urls: topRatedMovieImageURL)
            break
        case 4:
            (cell as! CategoryCell).UICategoryLabel.text = "Upcoming"
            updateCategoryCellImages(count: upcomingMovieImageURL.count, cell: cell as! CategoryCell, urls: upcomingMovieImageURL)
            break
        default:
            (cell as! CategoryCell).UICategoryLabel.text = "Now Playing"
            updateCategoryCellImages(count: imageURL.count, cell: cell as! CategoryCell, urls: imageURL)
            break
        }
    }
    
    // Method used to update the imageviews with the appropriate images.
    private func updateCategoryCellImages(count:Int, cell : CategoryCell, urls : [String?]){
        
        if(urls.count > 0){
            if nil != urls[0]{
                let url = URL(string: urls[0]!)
                print("url : ",url!)
                cell.UIImageMovie1.kf.indicatorType = .activity
                cell.UIImageMovie1.kf.setImage(with: url)
            }
            
            if nil != urls[1]{
                let url = URL(string: urls[1]!)
                print("url : ",url!)
                cell.UIImageMovie2.kf.indicatorType = .activity
                cell.UIImageMovie2.kf.setImage(with: url)
            }
            
            if nil != urls[2]{
                let url = URL(string: urls[2]!)
                print("url : ",url!)
                cell.UIImageMovie3.kf.indicatorType = .activity
                cell.UIImageMovie3.kf.setImage(with: url)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Callback method for list of latest movies
    private func onReceiveLatestMovies(data : JSON){
        var jsonData : JSON = JSON(data.dictionary!["results"]!)
        var index : Int = 0
        
        if 0 == index{
            latestmovieIds = [String!](repeating:nil, count:jsonData.count)
        }
        
        for i in 0..<jsonData.count {
            self.movieService.getImageURLs(url: "https://api.themoviedb.org/3/movie/"+jsonData[i]["id"].description+"/images?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&include_image_language=en,null"){ [weak self] (jsonImageData: JSON) in
                self?.onReceiveLatestImageURL(index: index, count: jsonData.count, data: jsonImageData)
                self?.latestmovieIds[index] = jsonData[i]["id"].description
                index = index + 1
            }
        }
    }
    
    // Callback method for list of noe playing movies
    private func onReceiveNowPlayingMovies(data : JSON){
        var jsonData : JSON = JSON(data.dictionary!["results"]!)
        var index : Int = 0
        
        if 0 == index{
            movieIds = [String!](repeating:nil, count:jsonData.count)
        }
        
        for i in 0..<jsonData.count {
            self.movieService.getImageURLs(url: "https://api.themoviedb.org/3/movie/"+jsonData[i]["id"].description+"/images?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&include_image_language=en,null"){ [weak self] (jsonImageData: JSON) in
                    self?.onReceiveImageURL(index: index, count: jsonData.count, data: jsonImageData)
                    self?.movieIds[index] = jsonData[i]["id"].description
                    index = index + 1
            }
        }
     }
    
    // Callback method for list of popular movies
    private func onReceivePopularMovies(data : JSON){
        var jsonData : JSON = JSON(data.dictionary!["results"]!)
        var index : Int = 0
        
        if 0 == index{
            popularmovieIds = [String!](repeating:nil, count:jsonData.count)
        }
        
        for i in 0..<jsonData.count {
            self.movieService.getImageURLs(url: "https://api.themoviedb.org/3/movie/"+jsonData[i]["id"].description+"/images?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&include_image_language=en,null"){ [weak self] (jsonImageData: JSON) in
                self?.onReceivePopularImageURL(index: index, count: jsonData.count, data: jsonImageData)
                self?.popularmovieIds[index] = jsonData[i]["id"].description
                index = index + 1
            }
        }
    }
    
    // Callback method for list of top rated movies
    private func onReceiveTopRatedMovies(data : JSON){
        var jsonData : JSON = JSON(data.dictionary!["results"]!)
        var index : Int = 0
        
        if 0 == index{
            topRatedmovieIds = [String!](repeating:nil, count:jsonData.count)
        }
        
        for i in 0..<jsonData.count {
            self.movieService.getImageURLs(url: "https://api.themoviedb.org/3/movie/"+jsonData[i]["id"].description+"/images?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&include_image_language=en,null"){ [weak self] (jsonImageData: JSON) in
                self?.onReceiveTopRatedImageURL(index: index, count: jsonData.count, data: jsonImageData)
                self?.topRatedmovieIds[index] = jsonData[i]["id"].description
                index = index + 1
            }
        }
    }
    
    // Callback method for list of upcoming movies
    private func onReceiveUpcomingMovies(data : JSON){
        var jsonData : JSON = JSON(data.dictionary!["results"]!)
        var index : Int = 0
        
        if 0 == index{
            upComingmovieIds = [String!](repeating:nil, count:jsonData.count)
        }
        
        for i in 0..<jsonData.count {
            self.movieService.getImageURLs(url: "https://api.themoviedb.org/3/movie/"+jsonData[i]["id"].description+"/images?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&include_image_language=en,null"){ [weak self] (jsonImageData: JSON) in
                self?.onReceiveUpcomingImageURL(index: index, count: jsonData.count, data: jsonImageData)
                self?.upComingmovieIds[index] = jsonData[i]["id"].description
                index = index + 1
            }
        }
    }
    
    // Callback method for list of latest movie images
    private func onReceiveLatestImageURL(index: Int, count: Int, data : JSON){
        if 0 == latestimageURL.count {
            latestimageURL = [String!](repeating:nil, count:count)
        }
        
        if(latestRefreshRequest && nil != latestimageURL[count - 1]){
            utilities.stopActivityIndicator()
            latestRefreshRequest = false
            UIMoviesTableView.reloadData()
            return
        }
        
        latestimageURL[index] = "http://image.tmdb.org/t/p/w780/"+data["posters"][0]["file_path"].description
        
        if count == latestMovierefreshCount && latestRefreshRequest
        {
            latestRefreshRequest = false
            UIMoviesTableView.reloadData()
            utilities.stopActivityIndicator()
            self.viewWillAppear(true)
        }
        latestMovierefreshCount = latestMovierefreshCount + 1
        
    }
    
    // Callback method for list of now playing movie images
    private func onReceiveImageURL(index: Int, count: Int, data : JSON){
        if 0 == imageURL.count {
            imageURL = [String!](repeating:nil, count:count)
        }
        
        if(nowPlayingRefreshRequest && nil != imageURL[count - 1]){
            utilities.stopActivityIndicator()
            nowPlayingRefreshRequest = false
            UIMoviesTableView.reloadData()
            return
        }
        
        imageURL[index] = "http://image.tmdb.org/t/p/w780/"+data["posters"][0]["file_path"].description
        
        if count == latestMovierefreshCount && nowPlayingRefreshRequest
        {
            nowPlayingRefreshRequest = false
            UIMoviesTableView.reloadData()
            utilities.stopActivityIndicator()
            self.viewWillAppear(true)
        }
        
        nowPlayingMovierefreshCount = nowPlayingMovierefreshCount + 1
    }
    
    // Callback method for list of popular movie images
    private func onReceivePopularImageURL(index: Int, count: Int, data : JSON){
        if 0 == popularMovieImageURL.count {
            popularMovieImageURL = [String!](repeating:nil, count:count)
        }
        
        if(popularRefreshRequest && nil != popularMovieImageURL[count - 1]){
            utilities.stopActivityIndicator()
            popularRefreshRequest = false
            UIMoviesTableView.reloadData()
            return
        }
        
        popularMovieImageURL[index] = "http://image.tmdb.org/t/p/w185/"+data["posters"][0]["file_path"].description
        
        if count == popularMovierefreshCount && popularRefreshRequest
        {
            popularRefreshRequest = false
            UIMoviesTableView.reloadData()
            utilities.stopActivityIndicator()
            self.viewWillAppear(true)
        }
        
        popularMovierefreshCount = popularMovierefreshCount + 1
    }
    
    // Callback method for list of top rated movie images
    private func onReceiveTopRatedImageURL(index: Int, count: Int, data : JSON){
        if 0 == topRatedMovieImageURL.count {
            topRatedMovieImageURL = [String!](repeating:nil, count:count)
        }
        
        if(topRefreshRequest && nil != topRatedMovieImageURL[count - 1]){
            utilities.stopActivityIndicator()
            topRefreshRequest = false
            UIMoviesTableView.reloadData()
            return
        }
        
        topRatedMovieImageURL[index] = "http://image.tmdb.org/t/p/w185/"+data["posters"][0]["file_path"].description
        
        if count == topMovierefreshCount && topRefreshRequest
        {
            topRefreshRequest = false
            UIMoviesTableView.reloadData()
            utilities.stopActivityIndicator()
            self.viewWillAppear(true)
        }
        
        topMovierefreshCount = topMovierefreshCount + 1
    }
    
    private func onReceiveUpcomingImageURL(index: Int, count: Int, data : JSON){
        if 0 == upcomingMovieImageURL.count {
            upcomingMovieImageURL = [String!](repeating:nil, count:count)
        }
        
        if(upcomingRefreshRequest && nil != upcomingMovieImageURL[count - 1]){
            utilities.stopActivityIndicator()
            upcomingRefreshRequest = false
            UIMoviesTableView.reloadData()
            return
        }
        
        upcomingMovieImageURL[index] = "http://image.tmdb.org/t/p/w185/"+data["posters"][0]["file_path"].description
        
        if count == upcomingMovierefreshCount && upcomingRefreshRequest
        {
            upcomingRefreshRequest = false
            UIMoviesTableView.reloadData()
            utilities.stopActivityIndicator()
            self.viewWillAppear(true)
        }
        
        upcomingMovierefreshCount = upcomingMovierefreshCount + 1
    }
}

// Extension for view controller to update collection view data
// The top most horizontal sliding view in Home page
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return latestimageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestMovieCell", for: indexPath) as! LatestMovieCell
        updateMoviePoster(cell: cell, row: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width-50, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // Method for updating the movie poster in Collection view cell.
    func updateMoviePoster(cell : LatestMovieCell,row : Int ){
        if 0 < latestimageURL.count{
            if(nil != latestimageURL[row]){
            let url = URL(string: latestimageURL[row])
                (cell as LatestMovieCell).UIMovieImageView.kf.indicatorType = .activity
                (cell as LatestMovieCell).UIMovieImageView.kf.setImage(with: url)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        UIView.transition(with: cell, duration: 0.8, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    ///Check if internet is connected
    func CheckInternetConnectivity()
    {
        let alertController = UIAlertController(title: "Network Alert", message: "Please connect to internet...", preferredStyle: .alert)
        
        //if internet not connected show alert
        if self.isActiveNetworkConnectionAvailable() == false
        {
            let action1 = UIAlertAction(title: "Done", style: .default) { (action:UIAlertAction) in
                self.CheckInternetConnectivity()
            }
            alertController.addAction(action1)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            //Dismiss the alert if internet gets connected
            if(alertController.isBeingPresented)
            {
                alertController.dismiss(animated: true, completion: {
                    self.FetchAllMoviesFromServer()
                })
            }
            else{
                self.FetchAllMoviesFromServer()
            }
        }
    }
    
    // Method returning true if the device has an active internet connection.
    func isActiveNetworkConnectionAvailable() -> Bool{
        ///Check internet connectivity
            
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }
            
            let isReachable = flags == .reachable
            let needsConnection = flags == .connectionRequired
            
            return isReachable && !needsConnection
            
    }
    
    // Method to check if the UI should be refreshed.
    private func refreshRequired() -> Bool{
        return latestRefreshRequest && nowPlayingRefreshRequest && popularRefreshRequest && topRefreshRequest && upcomingRefreshRequest
    }
}

// Custom tap gesture class.
class ImageTapGesture: UITapGestureRecognizer {
    var index : Int = 0
    var row : Int = 0
    var cell : CategoryCell? = nil
}
