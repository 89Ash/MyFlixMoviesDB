//
//  MovieService.swift
//  MyFlixMovies
//
//  Created by Ashray P Shetty on 8/22/18.
//  Copyright © 2018 Ashray P Shetty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// The service class responsible for Webservice interaction and invoking the registered completion handler
class MovieService{

    let API_KEY : String = "55957fcf3ba81b137f8fc01ac5a31fb5"
    let latestMovieURL : String = "https://api.themoviedb.org/3/movie/now_playing?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=1"
    
    let nowPlayingMoviesURL : String = "https://api.themoviedb.org/3/movie/now_playing?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=1"
    
    let popularMoviesURL : String = "https://api.themoviedb.org/3/movie/popular?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=1"
    
    let topRatedMoviesURL : String = "https://api.themoviedb.org/3/movie/top_rated?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=1"
    
    let upcomingMoviesURL : String = "https://api.themoviedb.org/3/movie/upcoming?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=1"
    
    func getLatestMovie(completion: @escaping ((_ data : JSON)->Void)){
        Alamofire.request(latestMovieURL).responseJSON{ response in
            if response.result.isSuccess
            {
                let json = JSON(response.result.value as Any)
                completion(json)
            }
        }
    }
    
    func getNowPlayingMovies(completion: @escaping ((_ data : JSON)->Void)){
        Alamofire.request(nowPlayingMoviesURL).responseJSON{ response in
            if response.result.isSuccess
            {
                let json = JSON(response.result.value as Any)
                completion(json)
            }
        }
    }
    
    func getPopularMovies(completion: @escaping ((_ data : JSON)->Void)){
        Alamofire.request(popularMoviesURL).responseJSON{ response in
            if response.result.isSuccess
            {
                let json = JSON(response.result.value as Any)
                completion(json)
            }
        }
    }
    
    func getTopRatedMovies(completion: @escaping ((_ data : JSON)->Void)){
        Alamofire.request(topRatedMoviesURL).responseJSON{ response in
            if response.result.isSuccess
            {
                let json = JSON(response.result.value as Any)
                completion(json)
            }
        }
    }
    
    func getUpcomingMovies(completion: @escaping ((_ data : JSON)->Void)){
        Alamofire.request(upcomingMoviesURL).responseJSON{ response in
            if response.result.isSuccess
            {
                let json = JSON(response.result.value as Any)
                completion(json)
            }
        }
    }
    
    func getImageURLs(url: String,completion: @escaping ((_ data : JSON)->Void)){
        Alamofire.request(url).responseJSON{ response in
            if response.result.isSuccess
            {
                let json = JSON(response.result.value as Any)
                completion(json)
            }
        }
    }
    
    func getMovieDetails(url: String,completion: @escaping ((_ data : JSON)->Void)){
        Alamofire.request(url).responseJSON{ response in
            if response.result.isSuccess
            {
                let json = JSON(response.result.value as Any)
                completion(json)
            }
        }
    }
    
    func getMovieTrailerURL(url: String,completion: @escaping ((_ data : JSON)->Void)){
        Alamofire.request(url).responseJSON{ response in
            if response.result.isSuccess
            {
                let json = JSON(response.result.value as Any)
                completion(json)
            }
        }
    }
    
    
}
