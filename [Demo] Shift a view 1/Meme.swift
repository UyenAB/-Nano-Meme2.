//
//  Meme.swift
//  [Demo] Shift a view 1
//
//  Created by admin on 12/10/16.
//  Copyright © 2016 LEVUANHUYEN. All rights reserved.
//

import Foundation
import UIKit


struct Meme {
    
    
    // Meme elements
    var top: String
    var bottom: String
    var image: UIImage
    var memedImage: UIImage    // The actual meme image. It was built using the meme elemets
    

    
    init(top: String, bottom: String, image: UIImage, memedImage: UIImage) {
        self.top = top
        self.bottom = bottom
        self.image = image
        self.memedImage = memedImage
    }
    
    init(){
        self.top = ""
        self.bottom = ""
        self.image = UIImage()
        self.memedImage = UIImage()

    }
    
}

