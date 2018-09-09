//
//  MovieTrailerViewController.swift
//  MyFlixMovies
//
//  Created by Ashray P Shetty on 8/26/18.
//  Copyright © 2018 Ashray P Shetty. All rights reserved.
//

import UIKit
import WebKit

// The View Controller loading the trailer of the selected movie in an in-app WebView
class MovieTrailerViewController: UIViewController {

    var trailerUrl : String = ""
    @IBOutlet weak var UIMovieTrailerWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIMovieTrailerWebView.load(URLRequest(url: URL(string: trailerUrl)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
