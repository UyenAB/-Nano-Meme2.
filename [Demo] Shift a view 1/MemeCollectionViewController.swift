//
//  MemeCollectionViewController.swift
//  [Demo] Shift a view 1
//
//  Created by admin on 1/6/17.
//  Copyright © 2017 LEVUANHUYEN. All rights reserved.
//
import Foundation
import UIKit


class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var memes: [Meme]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh the local memes reference
        memes = MemeManager.sharedInstance.memes
        // Refresh the collection
        collectionView.reloadData()
    }
    
    // MARK: -
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    // MARK: -
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[(indexPath as NSIndexPath).row]
        
        let destinationController = storyboard?.instantiateViewController(withIdentifier: "MemeDetail") as! MemeDetailViewController
        destinationController.meme = meme
        destinationController.memeIndex = (indexPath as NSIndexPath).row
        
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    
    // MARK: -
    // MARK: Actions
    
    @IBAction func createMeme(_ sender: UIBarButtonItem) {
        presentMemeEditor()
    }
    
    // MARK: -
    // MARK: Utilities
    
    func presentMemeEditor() {
        let memeEditorController = storyboard!.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorVC
        
        self.present(memeEditorController, animated: true, completion: nil)
    }
}
