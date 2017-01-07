//
//  MemeDetailViewController.swift
//  [Demo] Shift a view 1
//
//  Created by admin on 1/5/17.
//  Copyright © 2017 LEVUANHUYEN. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeIndex: Int!
    var meme = Meme()
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func deleteButton(_ sender: UIButton) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(MemeDetailViewController.editMeme))
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MemeManager.sharedInstance.deleteMemeAtIndex(index: self.memeIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func editMeme(sender: UIBarButtonItem){
        let memeEditorController = storyboard?.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorVC
        memeEditorController.meme = meme
        present(memeEditorController, animated: true, completion: nil)
        
        
        
    }
    
    
}
