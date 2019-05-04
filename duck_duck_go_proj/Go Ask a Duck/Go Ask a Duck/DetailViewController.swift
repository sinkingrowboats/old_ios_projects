//
//  DetailViewController.swift
//  Go Ask a Duck
//
//  Created by Samantha Rey on 8/11/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

//- Attribution: http://www.korestate.com/images/fav.png: Favorite Icon
//- Attribution: https://developer.apple.com/documentation/uikit/uiactivityindicatorview UIActivityIndicatorView Documentation
class DetailViewController: UIViewController, UIWebViewDelegate {
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favicon: UIImageView!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            let lastResultArray: [String] = [detail.resultURL, detail.resultDescription, detail.queryString]
            defaults.set(lastResultArray, forKey: "lastResultArray")
            defaults.synchronize()
            
            if let addB = addButton {
                addB.title = "Bookmark this Article"
            }
            if let www = webView {
                let myURL = URL(string: detail.resultURL)
                let myURLRequest:URLRequest = URLRequest(url: myURL!)
                www.loadRequest(myURLRequest)
            }
            if let bookmarkData = defaults.object(forKey:"bookmarkDict") as? [String: [String]] {
                print("old bookmark dict")
                if let fav = favicon {
                    if(bookmarkData.keys.contains(detail.resultURL)) {
                        fav.alpha = 1
                    }
                    else {
                        fav.alpha = 0
                    }
                }
            }
            
        }
        else {
            addButton.title = ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        let _ = self.view
        // Do any additional setup after loading the view, typically from a nib.
        if let lastResultArray = defaults.object(forKey: "lastResultArray") as? [String] {
            detailItem = Result(resultURL: lastResultArray[0], resultDescription: lastResultArray[1], queryString: lastResultArray[2])
        }
        else {
            configureView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Result? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    @IBAction func addBookmark(sender: UIBarButtonItem){
        if let detail = detailItem {
            if var bookmarkData = defaults.object(forKey:"bookmarkDict") as? [String: [String]] {
                print("old bookmark dict")
                
                if(!bookmarkData.keys.contains(detail.resultURL)) {
                    print("this page was not previously favorited")
                    bookmarkData[detail.resultURL] = [detail.resultURL, detail.resultDescription, detail.queryString]
                    
                    defaults.set(bookmarkData, forKey:"bookmarkDict")
                }
            }
            else {
                print("new bookmark dict")
                let bookmarkData: [String: [String]] = [detail.resultURL:
                        [detail.resultURL,detail.resultDescription,
                        detail.queryString]]
                defaults.set(bookmarkData, forKey:"bookmarkDict")
            }
            defaults.synchronize()
            
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
    }

}

extension DetailViewController: DetailBookmarkDelegate {
    func bookmarkPassedURL(result: Result) {
        /*
        if let addB = addButton {
            addB.title = "Bookmark this Article"
        }
        if let www = webView {
            let myURL = URL(string: result.resultURL)
            let myURLRequest:URLRequest = URLRequest(url: myURL!)
            www.loadRequest(myURLRequest)
        }
        */
        detailItem = result
    }
    
    //- Attribution: https://makeapppie.com/2016/06/30/adding-modal-views-and-popovers-in-swift-3-0/ Help with adding the popover segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "murdersegue" {
            if let view = segue.destination as? BookmarkTableViewController {
                view.delegate = self
            }
        }
    }
}
