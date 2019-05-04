//
//  JSONServices.swift
//  Go Ask a Duck
//
//  Created by Samantha Rey on 8/12/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

//NOTE: I had finished the JSONSerialization Networking portion prior to
//reading the end of the assignment, as such, my singleton Networking class
//is called "JSONServices", not "SharedNetworking" as stipulated in the guidelines.

class JSONServices {
    //
    // MARK: - Properties
    //
    
    let dataSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    
    //
    // MARK: - Custom Methods
    //
    
    /// Get the Issue Json Data with a URL Session
    func getResultData(query: String, completion: @escaping ([Result], String) -> ()) {
        dataTask?.cancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        errorMessage = ""
        
        let query2 = query.replacingOccurrences(of: " ", with: "+")
        
        let queryURLOpt = URL(string: "http://api.duckduckgo.com/?q=\(query2)&format=json&pretty=1")
        guard let queryURL = queryURLOpt else{
            self.errorMessage += "Bad request URL"
            DispatchQueue.main.async {
                completion([], self.errorMessage)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            return
        }
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: queryURL as URL)
        dataTask = dataSession.dataTask(with: urlRequest as URLRequest) { data, response, error in
            defer {self.dataTask = nil}
            
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                DispatchQueue.main.async {
                    completion([], self.errorMessage)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    
                    if(json.isEmpty) {
                        DispatchQueue.main.async {
                            completion([], self.errorMessage)
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(Result.parseJSONResults(results: json, query: query), "")
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                    
                }
                catch {
                    self.errorMessage += "Error serializing JSON: \(error)\n"
                    DispatchQueue.main.async {
                        completion([], self.errorMessage)
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
            
            else {
                self.errorMessage += "Bad response\n"
                DispatchQueue.main.async {
                    completion([], self.errorMessage)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
        
        dataTask?.resume()
    }
    
}
