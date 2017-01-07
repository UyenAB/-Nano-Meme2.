//
//  MemeManager.swift
//  [Demo] Shift a view 1
//
//  Created by admin on 12/10/16.
//  Copyright © 2016 LEVUANHUYEN. All rights reserved.
//

import Foundation
struct MemeManager {
    
    private static var __once: () = {
        Static.instance = MemeManager()
    }()
    
    // Singleton pattern: http://code.martinrue.com/posts/the-singleton-pattern-in-swift
    static var sharedInstance: MemeManager {
        struct Static {
            static var instance: MemeManager?
            static var token: Int = 0
        }
        
        _ = MemeManager.__once
        
        return Static.instance!
    }

    
    
    
    
    
    
    // Shared model representing the list of sent memes
    var memes = [Meme]()
    
     mutating func deleteMemeAtIndex(index: Int) {
        memes.remove(at: index)
    }
    
    mutating func appendMeme(meme: Meme) {
        memes.append(meme)
    }
 

        
        

 
    
    


    }
