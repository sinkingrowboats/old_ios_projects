//
//  BookmarkTableViewController.swift
//  Go Ask a Duck
//
//  Created by Samantha Rey on 8/11/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

//- Attribution: https://www.youtube.com/watch?v=jr9pJ27rkvw really saving my butt on understanding Delegates, I was missing some key words to gettin gthis to work, the video really help since there weren't that many resources
protocol DetailBookmarkDelegate: class {
    func bookmarkPassedURL(result: Result) -> Void
}

class BookmarkTableViewController: UITableViewController {
    
    weak var delegate: DetailBookmarkDelegate?
    
    let defaults = UserDefaults.standard
    
    var bookmarkDict = [String: Result]()
    var bookmarks: [Result] = []
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bookmarkData = defaults.object(forKey:"bookmarkDict") as? [String: [String]] {
                for (_, resultData) in bookmarkData{
                    let result = Result(resultURL: resultData[0],
                                        resultDescription: resultData[1],
                                        queryString: resultData[2])
                    bookmarks.append(result!)
                }
        }
        self.tableView.reloadData()
        
        let closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(close(_:)))
        let editButton = editButtonItem
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        toolbar.items = [closeButton, flexibleSpace, editButton]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BookmarkTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BookmarkTableViewCell else {
            fatalError("The dequeued cell is not an instance of BookmarkTableViewCell.")
        }
        
        cell.label.text = bookmarks[indexPath.row].resultURL
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let resultRemoving = bookmarks[indexPath.row]
            if var bookmarkData = defaults.object(forKey:"bookmarkDict") as? [String: [String]] {
                bookmarkData.removeValue(forKey: resultRemoving.resultURL)
                defaults.set(bookmarkData, forKey:"bookmarkDict")
            }
            defaults.synchronize()
            
            bookmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        let selectedBookmark = bookmarks[indexPath.row]
        self.dismiss(animated: true, completion: nil)
        delegate?.bookmarkPassedURL(result: selectedBookmark)
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
