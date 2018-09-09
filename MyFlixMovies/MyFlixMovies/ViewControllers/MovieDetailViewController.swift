//
//  MovieDetailViewController.swift
//  MyFlixMovies
//
//  Created by Ashray P Shetty on 8/24/18.
//  Copyright © 2018 Ashray P Shetty. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher
import SystemConfiguration

// The view controller displayed on clicking movie image in Home Screen(ViewController) and MoviesBannerViewController
class MovieDetailViewController: UIViewController {

    public var movieId : String!
    
    @IBOutlet weak var UIReleaseDateLabel: UILabel!
    @IBOutlet weak var UIRatingLabel: UILabel!
    
    @IBOutlet weak var UIWatchTrailerButton: UIButton!
    @IBOutlet weak var UIMoviePosterImageView: UIImageView!
    
    @IBOutlet weak var UIMovieTitleLabel: UILabel!
    @IBOutlet weak var UIMovieTagLineLabel: UILabel!
    
    @IBOutlet weak var UIOverviewText: UITextView!
    
    let movieService : MovieService = MovieService()
    
    var movieDetailsURL : String = ""
    
    var movieTrailerURL : String = ""
    
    var utitlities = Utilities()
    
    var alertController : UIAlertController!
    
    var isUrlRetrieved : Bool = false
    
    @IBAction func WatchTrailerButtonCLick(_ sender: Any) {
    
        //UIApplication.shared.open(url, options: [:])
        performSegue(withIdentifier: "MovieTrailerViewController", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        
        CheckInternetConnectivity()
        
    }
    
    // Get the movie details from wenservice
    func getDataForWebService(){
        utitlities.startActivityIndicator(view: self.view)
        
        movieDetailsURL = "https://api.themoviedb.org/3/movie/"+movieId+"?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US"
        movieService.getMovieDetails(url: movieDetailsURL, completion:{ [weak self] (jsonData: JSON) in
            self?.onReceiveMovieDetails(data: jsonData)
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIWatchTrailerButton.isEnabled = isUrlRetrieved
        UIWatchTrailerButton.isUserInteractionEnabled = isUrlRetrieved
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Callback invoked on receiving the movie details.
    private func onReceiveMovieDetails(data : JSON){
        let movieImageUrl : String = "http://image.tmdb.org/t/p/w780/"+data["poster_path"].description
        UIMoviePosterImageView.kf.setImage(with: URL(string: movieImageUrl))
        
        UIReleaseDateLabel.text = data["release_date"].description
        UIRatingLabel.text = data["vote_average"].description
        
        UIMovieTitleLabel.text = data["title"].description
        UIMovieTagLineLabel.text = data["tagline"].description
        UIOverviewText.text = data["overview"].description
        
        let trailerRequestURL : String = "https://api.themoviedb.org/3/movie/"+self.movieId+"/videos?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US"
        movieService.getMovieTrailerURL(url: trailerRequestURL, completion:{ [weak self] (jsonData: JSON) in
            self?.onReceiveMovieTrailerURL(data: jsonData)
        })
    }
    
    // Callback invoked on receiving the movie trailer URL
    private func onReceiveMovieTrailerURL(data: JSON){
        movieTrailerURL = "https://www.youtube.com/watch?v="+data["results"][0]["key"].description
        UIWatchTrailerButton.isEnabled = true
        UIWatchTrailerButton.isUserInteractionEnabled = true
        
        utitlities.stopActivityIndicator()
        isUrlRetrieved = true
    }

    // Method for calling the view controller to load the webview with the trailer URL.
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        let movieTrailerVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieTrailerViewController") as! MovieTrailerViewController
        movieTrailerVC.trailerUrl = movieTrailerURL
        self.navigationController?.pushViewController(movieTrailerVC, animated: true)
    }
    
    ///Check if internet is connected
    func CheckInternetConnectivity()
    {
        alertController = UIAlertController(title: "Network Alert", message: "Please connect to internet...", preferredStyle: .alert)
        //if internet not connected show alert
        if self.isActiveNetworkConnectionAvailable() == false
        {
            let action1 = UIAlertAction(title: "Done", style: .default) { (action:UIAlertAction) in
                self.CheckInternetConnectivity()
            }
            alertController.addAction(action1)
            
            self.present(alertController, animated: true, completion: nil)
            utitlities.stopActivityIndicator()
        }
        else
        {
            //Dismiss the alert if internet gets connected
            if(alertController.isBeingPresented)
            {
                alertController.dismiss(animated: true, completion: {
                    self.getDataForWebService()
                })
            }
            else{
                self.getDataForWebService()
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
}
