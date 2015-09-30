//
//  PlistData.swift
//  LosBarkitosIpad
//
//  Created by chus on 14/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation


class DataManager: NSObject {
    
    /**
    Guarda en una .plist valores
    
    - parameter key:   la key donde debe almacenarlo
    - parameter value: el valor a guardar
    - parameter file:  el fichero a generar
    */
    func setValueForKey(key: String, value: AnyObject, inFile file:String) {
        
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        path = (path as NSString).stringByAppendingPathComponent(file)
        let filename = path + ".plist"
        
        var dict = NSMutableDictionary(contentsOfFile: filename)
        
        if dict == nil {
            dict = NSMutableDictionary()
        }
        
        dict?.setValue(value, forKey: key)
        dict?.writeToFile(filename, atomically: true)
        
    }
    
    /**
    Carga de una .plist valores
    
    - parameter key:  la key a cargar
    - parameter file: el fichero a leer
    
    - returns: el valor encontrado
    */
    func getValueForKey(key: String, inFile file:String) -> AnyObject? {
        
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        path = (path as NSString).stringByAppendingPathComponent(file)
        let filename = path + ".plist"
        
        let dict = NSMutableDictionary(contentsOfFile: filename)
        
        if dict != nil {
            return dict?.valueForKey(key)
        }
        else {
            return nil
        }
        
    }
    
}