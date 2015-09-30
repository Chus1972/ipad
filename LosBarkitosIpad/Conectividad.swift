//
//  Conectividad.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 21/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation
protocol ConectividadProtocol {
    func conectado()
}
class Conectividad : NSObject {
    var delegate : ConectividadProtocol?
    var hay : Bool = false
    func estaConectado () -> Bool {
    print("ENTRA")
     //   let reachability : Reachability = Reachability.reachabilityForInternetConnection()
        
       // reachability.whenReachable = { reachability in
           
         //   if reachability.isReachableViaWiFi() {
           //     print("Reachable via WIFI")
             //   self.hay = true
            //} else {
            //    print("Reachable via Cellular")
           // }
            
       // }
        //reachability.startNotifier()
       // print (reachability.startNotifier())
        
        return true
    }
}