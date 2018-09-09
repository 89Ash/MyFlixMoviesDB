//
//  Utilities.swift
//  MyFlixMovies
//
//  Created by Ashray P Shetty on 8/26/18.
//  Copyright © 2018 Ashray P Shetty. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var isActivityIndicatorDisplayed : Bool = false
    
    // Method for displaying the full screen activity indicator
    public func startActivityIndicator(view: UIView) {
        
        if(isActivityIndicatorDisplayed){
            return
        }
        
        isActivityIndicatorDisplayed = true
        let screenSize: CGRect = UIScreen.main.bounds
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        
        // Change background color and alpha channel here
        activityIndicator.backgroundColor = UIColor.black
        activityIndicator.clipsToBounds = true
        activityIndicator.alpha = 0.5
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    // Method for dismissing the full screen activity indicator
    public func stopActivityIndicator() {
        isActivityIndicatorDisplayed = false
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }

}
