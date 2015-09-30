//
//  UtilidadesBDDSQLITE.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 27/2/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation
import UIKit

class UtilidadesBDDSQLITE : NSObject {
    
    class func getPath(fileName : String) -> String {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] 
        let path = (documentsFolder as NSString).stringByAppendingPathComponent(fileName)
        print(path)
        
        return path
    }
    
    class func copyFile(fileName : NSString) {
        let dbPath : String = getPath(fileName as String)

        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(dbPath) {
            let fromPath : String = (NSBundle.mainBundle().resourcePath as NSString!).stringByAppendingPathComponent(fileName as String)
            
            do {
                try fileManager.copyItemAtPath(fromPath, toPath: dbPath)
            } catch _ {
            }
        }
    }
}