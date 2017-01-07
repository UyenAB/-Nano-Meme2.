//
//  MemeTableViewController.swift
//  [Demo] Shift a view 1
//
//  Created by admin on 1/5/17.
//  Copyright © 2017 LEVUANHUYEN. All rights reserved.
//
import Foundation
import UIKit

class MemeTableViewController: UITableViewController{

    var memes: [Meme]!
    var editorNotPresented = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the edit buttom in the navigation bar
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = MemeManager.sharedInstance.memes  // Refresh the local memes

      
        tableView.reloadData()  // Refresh the table list
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // The editor should be presented if there are no sent memes
        if memes.count == 0 && editorNotPresented {
            editorNotPresented = false
            // No memes. Lets present the editor
            presentCleanMemeEditor()
        }
    }
    
    
    
    // MARK: -
    // MARK: UITableViewDataSource
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell") as! TableViewCell
        
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.memeImageView.image = meme.memedImage
        cell.memeLabel.text = buildMemeTextSummary(meme)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            removeMemeAtIndexPath(indexPath)
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: -
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt:IndexPath) -> [AnyObject]? {
        // Edit action
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit", handler: { (action, indexPath) -> Void in
            let meme = self.memes[(indexPath as NSIndexPath).row]
            self.presentMemeEditor(meme)
        })
        // Delete action
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: { (action, indexPath) -> Void in
            self.removeMemeAtIndexPath(indexPath)
        })
        
        let arrayofactions: Array = [delete, edit]
        
        return arrayofactions
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[(indexPath as NSIndexPath).row]
        
        let destinationController = storyboard?.instantiateViewController(withIdentifier: "MemeDetail") as! MemeDetailViewController
        destinationController.meme = meme
        destinationController.memeIndex = (indexPath as NSIndexPath).row
        
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    func buildMemeTextSummary(_ meme: Meme) -> String {
        let topCount = meme.top.characters.count
        let bottomCount = meme.bottom.characters.count
        
        var topSubstring = meme.top
        var bottomSubstring = meme.bottom
        
        return "\(topSubstring). \(bottomSubstring)"
    }
    
    func presentCleanMemeEditor() {
        presentMemeEditor(nil)
    }
    // Correclty removes the meme from the model and the table
    func removeMemeAtIndexPath(_ indexPath: IndexPath) {
        // remove the deleted item from the model
        MemeManager.sharedInstance.deleteMemeAtIndex(index: (indexPath as NSIndexPath).row)
        memes = MemeManager.sharedInstance.memes
        // remove the deleted item from the `UITableView`
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    // Presents the meme editor. Uses a existing meme if is provided as a parameter
    func presentMemeEditor(_ meme: Meme?) {
        let memeEditorController = storyboard!.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorVC
        if let existingMeme = meme {
            memeEditorController.meme = existingMeme
        }
        self.present(memeEditorController, animated: true, completion: nil)
    }

}
