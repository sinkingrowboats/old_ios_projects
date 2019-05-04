//
//  Result.swift
//  Go Ask a Duck
//
//  Created by Samantha Rey on 8/12/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

class Result: NSObject {
    //
    // MARK: - Properties
    //
    
    var resultURL: String
    var resultDescription: String
    var queryString: String
    
    //
    // MARK: - Initialization
    //
    
    init?(resultURL: String, resultDescription: String, queryString: String) {
        
        // The resultURL must not be empty
        guard !resultURL.isEmpty else {
            return nil
        }
        
        // The resultDescription must not be empty
        guard !resultDescription.isEmpty else {
            return nil
        }
        
        // The queryString must not be empty
        guard !queryString.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.resultURL = resultURL
        self.resultDescription = resultDescription
        self.queryString = queryString
    }
    
    //
    // MARK: - Parsing Methods
    //
    
    /// Parse JSON Issue Data and create an array of Issue objects that can
    /// be handled by a TableViewController
    static func parseJSONResults(results: [String: Any], query: String)->[Result] {
        var newResults: [Result] = []
        let topics = results["RelatedTopics"] as! [[String:Any]]
        for result in topics {
            if(!result.keys.contains("Topics")){
                let url = result["FirstURL"] as! String
                let description = result["Text"] as! String
            
                guard let newResult = Result(resultURL: url, resultDescription: description, queryString: query) else {
                    print("Result could not be created for some reason")
                    return newResults
                }
                newResults.append(newResult)
            }
        }
        return newResults
    }

}
