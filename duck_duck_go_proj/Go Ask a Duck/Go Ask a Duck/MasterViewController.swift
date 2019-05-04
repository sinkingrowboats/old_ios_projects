//
//  MasterViewController.swift
//  Go Ask a Duck
//
//  Created by Samantha Rey on 8/11/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {
    
    let defaults = UserDefaults.standard
    
    var themeManager = Theme()
    
    var detailViewController: DetailViewController? = nil
    
    let jsonservice = JSONServices()
    var results: [Result] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        
        //- Attribution: https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started Figuring out how to handle the delegates for the SearchController and Search Bar Controllers
        //searchController.searchResultsUpdater = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        themeManager.setColors()
        
        var queryterm = "apple"
        
        if let lastSearched = defaults.object(forKey: "lastSearched") as? String {
            queryterm = lastSearched
        }
        jsonservice.getResultData(query: queryterm, completion: updateResults)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = results[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                //FIXME: YOU NEED TO LOAD THE UIVIEW HERE
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MasterTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MasterTableViewCell else {
            fatalError("The dequeued cell is not an instance of MasterTableViewCell.")
        }
        
        cell.label.text = results[indexPath.row].resultURL
        cell.descriptiveText.text = results[indexPath.row].resultDescription
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    // MARK: Private Methods
    private func updateResults(newResults: [Result], errorMessage: String) {
        if(!errorMessage.isEmpty){
            let alert = UIAlertController(title: "Error",
                                          message: "Bad Response/Request",
                                          preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            //Do popup
            print(errorMessage)
        }
        else if(newResults.isEmpty) {
            let alert = UIAlertController(title: "No Results Found",
                                          message: "Your search term is out of Quack! No results found. Try Again!",
                                          preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            //Do popup

            print("Your search term is out of Quack! No results found. Try Again!")
        }
        else {
            defaults.set(newResults[0].queryString, forKey: "lastSearched")
            defaults.synchronize()
            
            results = newResults
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if(text != "") {
                jsonservice.getResultData(query: text, completion: updateResults)
            }
        }
    }

}


