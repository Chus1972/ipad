//
//  Conexion.swift
//  LosBarkitosIpad
//  Esta clase implementa  las llamadas al webservice
//  Created by Jesus Valladolid Rebollar on 21/11/14.
//  Copyright (c) 2014 Jesus Valladolid Rebollar. All rights reserved.
//

import Foundation
//import UIkit

// Protocolo a implementar por la clase que delegue esta
 protocol WebServiceProtocoloVentas {
    // funcion que implementará la clase delegada y que recibirá los datos de repuesta a la llamada
    func didReceiveResponse_listadoVendedores(respuesta : [String : AnyObject])
    //func didReceiveResponse_listadoVentas(respuesta : [String : AnyObject])
    func didReceiveResponse_totalBarcas(respuesta : [String : Int])
    func didReceiveResponse_totalEuros(respuesta : [String : Int])
    //func didReceiveResponse_reserva(respuesta : [String : AnyObject])
    func didReceiveResponse_cierreDia(respuesta : String)
    
}

protocol WebServiceProtocoloPrecio {
    func didReveiveResponse_numeroTicket(respuesta : [String : AnyObject])
    func didReceiveResponse_entradaBDD_ventaBarca(respuesta : [String : AnyObject])

}

protocol WebServiceProtocoloControl {
    func didReceiveResponse_primeraLibre(respuesta : [String : [String : String]])
    func didReceiveResponse_listaLlegadas(respuesta : [String : AnyObject])
    func didReceiveResponse_listaReservas(respuesta : [String : AnyObject])
    func didReceiveResponse_salida(respuesta : [String : String])
    func didReceiveResponse_llegada(respuesta : [String : String])
    func didReceiveResponse_barcasFuera(respuesta : [String : [Int]])
    func didReceiveResponse_siguienteBarcaLlegar(_: [String : String])
    func didReceiveResponse_salidaReserva(_: String, tipo: Int)
    func didReceiveResponse_reservasPorDar(_: [String : AnyObject])
}

protocol WebServiceReserva {
    func didReceiveResponse_reservaPosible(respuesta : [Bool])
    func didReceiveResponse_reserva(respuesta : [String : AnyObject])
}

protocol WebServiceListado {
    func didReceiveResponse_listadoVentas(_: [String : AnyObject])
}

// PRUEBA DE CONEXIÓN CON WEBSERVICE A TRAVES DE AFNETWORKING
class webServiceCallAPI : NSObject {
    
    var delegate : WebServiceProtocoloVentas?
    var delegateControl : WebServiceProtocoloControl?
    var delegateReserva : WebServiceReserva?
    var delegateListado : WebServiceListado?
    var delegatePrecio : WebServiceProtocoloPrecio?
    
    let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()

    var responseObject : AnyObject?
    
    // Esta llamada devuelve una lista con los vendedores del sistema
    func obtenerVendedores()  {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        manager.GET(
            "http://losbarkitos.herokuapp.com/vendedores/",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                print("responseObject: \(responseObject.description)")
                var indice : Int = 1
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as! [String : AnyObject] {
                    if k != "error" {
                        diccionario[k] = v
                    } else if v as! NSString == "si" {// la respuesta es erronea
                        print("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }// hay un error y hay que paralo
                }
                print("diccionario: \(diccionario)")
                self.delegate?.didReceiveResponse_listadoVendedores(diccionario)// as NSDictionary)
            },
            
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                print("Error: \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegate?.didReceiveResponse_listadoVendedores(diccionario as Dictionary)// as NSDictionary)
            }
        )
        
    }
    
    func obtenerVentas() {
        var jsonDict :  NSDictionary!
        var jsonArray : NSArray!
        var error :     NSError?
        var puntoVenta : Int = 0
        var url : String = "http://losbarkitos.herokuapp.com/listado_viaje/1/2"
        if IPAD == "MARINAFERRY" {
            url = "http://losbarkitos.herokuapp.com/listado_viaje/1/5"
        }

        
        manager.GET(url,
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                 var indice : Int = 1
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as! [String : AnyObject] {
                    if k != "error" {
                        diccionario[k] = v
                    } else if v as! NSString == "si" { // la respuesta es errónea
                        print("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }
                }
                print("diccionario : \(diccionario)")

                self.delegateListado?.didReceiveResponse_listadoVentas(diccionario as Dictionary)
            },
            
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                print("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegateListado?.didReceiveResponse_listadoVentas(diccionario as Dictionary)
            }
        )
    }
    
    func entradaBDD_ventaBarca(ticket :Int, tipo : Int, precio : Int, puntoVenta : Int, vendedor : Int, negro : Bool) {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        var ticketBlanco : String = "0"
        
        if negro == false {
            ticketBlanco = "1"
        }
        if ticket == 0 {
            ticketBlanco = "0"
        }
        
        manager.GET(
            "http://losbarkitos.herokuapp.com/registro_barca/\(ticket)/\(tipo)/\(precio)/\(puntoVenta)/\(vendedor)/\(ticketBlanco)/", parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as! [String : AnyObject] {
                    if k != "error" {
                        diccionario[k] = v
                    } else if v as! Int == 1 {// la respuesta es erronea
                        print("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }
                }
                print("diccionario : \(diccionario)")
                self.delegatePrecio?.didReceiveResponse_entradaBDD_ventaBarca(diccionario as Dictionary)
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                print("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegatePrecio?.didReceiveResponse_entradaBDD_ventaBarca(diccionario as Dictionary)
            }
        )
    }
    
    func obtenerNumero(precio : Int) {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        manager.GET(
            "http://losbarkitos.herokuapp.com/ultimo_numero/\(precio)",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as! [String : AnyObject] {
                    if k != "error" || (k == "error" && v as! NSString == "no"){
                        diccionario[k] = v
                    } else if k == "error" &&  v as! String == "si" {// la respuesta es erronea
                        print("HAY UN ERROR QUE VIENE DEL SERVIDOR en ultimoNumero")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }
                }
                print("diccionario : \(diccionario)")
                self.delegatePrecio?.didReveiveResponse_numeroTicket(diccionario as Dictionary)
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                print("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegatePrecio?.didReveiveResponse_numeroTicket(diccionario as Dictionary)
            }
        )
    }
    
    func totalBarcas(PV : Int) {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        manager.GET("http://losbarkitos.herokuapp.com/total_barcas/\(PV)", parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                var diccionario = [String : Int]()
                for (k,v) in responseObject as! [String : Int] {
                    if k != "error" {
                        diccionario[k] = v
                    } else {
                        print("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario["error"] = 1
                    }
                }
                print("diccionario : \(diccionario)")
                self.delegate?.didReceiveResponse_totalBarcas(diccionario as Dictionary)
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                print("Error \(error.localizedDescription)")
                var diccionario = [String : Int]()
                diccionario["error"] = 1
                self.delegate?.didReceiveResponse_totalBarcas(diccionario as Dictionary)
        })
    }
    
    func totalEuros(PV : Int)  {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        manager.GET("http://losbarkitos.herokuapp.com/total_euros/\(PV)", parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                var diccionario = [String : Int]()
                for (k,v) in responseObject as! [String : Int] {
                    if k != "error" {
                        diccionario[k] = v
                    } else {
                        print("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario["error"] = 1
                    }
                }
                print("diccionario : \(diccionario)")
                self.delegate?.didReceiveResponse_totalEuros(diccionario as Dictionary)
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                print("Error \(error.localizedDescription)")
                var diccionario = [String : Int]()
                diccionario["error"] = 1
                self.delegate?.didReceiveResponse_totalEuros(diccionario as Dictionary)
        })        
    }
    
    func obtenerPrimerLibre() {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        manager.GET("http://losbarkitos.herokuapp.com/primera_libre",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                print("responseObject : \(responseObject)")
                self.delegateControl?.didReceiveResponse_primeraLibre(responseObject as! [String : [String : String]])
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                print("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegatePrecio?.didReveiveResponse_numeroTicket(diccionario as Dictionary)
            }
        )
    }
    
    func listaLlegadas(tipo : Int) {
        
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        var parametro : String =  String()
        
        switch tipo {
        case 1:
            parametro = "Rio"
        case 2:
            parametro = "Electrica"
        case 3:
            parametro = "Whaly"
        case 4:
            parametro = "Gold"
        default:
            parametro = "Rio"
        }
        
        manager.GET("http://losbarkitos.herokuapp.com/orden_llegada/\(parametro)",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                var indice : Int = 1
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as! [String : AnyObject] {
                    if k != "error" {
                        diccionario[k] = v
                    } else if v as! NSString == "si" { // la respuesta es errónea
                        print("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }
                }
                print("diccionario : \(diccionario)")
                
                self.delegateControl?.didReceiveResponse_listaLlegadas(diccionario as Dictionary)

            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                print("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegateControl?.didReceiveResponse_listaLlegadas(diccionario as! [String : [String : String]])
            }
        )
        
    }
    
    
    func listaReservas(tipo : Int) {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        var parametro : String =  String()
        
        switch tipo {
        case 1:
            parametro = "Rio"
        case 2:
            parametro = "Electrica"
        case 3:
            parametro = "Whaly"
        case 4:
            parametro = "Gold"
        default:
            parametro = "Rio"
        }
        
        manager.GET("http://losbarkitos.herokuapp.com/listado_reservas/\(parametro)/",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                var indice : Int = 1
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as! [String : AnyObject] {
                    if k != "error" {
                        diccionario[k] = v
                    } else if v as! NSString == "si" { // la respuesta es errónea
                        print("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }
                }
                print("diccionario : \(diccionario)")
                
                self.delegateControl?.didReceiveResponse_listaReservas(diccionario as [String : AnyObject])
                
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                print("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegateControl?.didReceiveResponse_listaReservas(diccionario as! [String : [String : String]])
            }
        )
 
    }
    
    func obtenerNumeroReserva(tipo : Int, pv : Int) {
        var jsonDict : NSDictionary!
        var jsonArray : NSArray!
        var error : NSError?
        
        manager.GET("http://losbarkitos.herokuapp.com/reserva/\(tipo)/\(pv)",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                print("responseObject : \(responseObject)")
                var diccionario = [String : AnyObject]()
                for (k,v) in responseObject as! [String : AnyObject] {
                    if k != "error" {
                        diccionario[k] = v
                    } else if v as! NSString == "si" { // la respuesta es errónea
                        print("HAY UN ERROR QUE VIENE DEL SERVIDOR")
                        diccionario = [String : AnyObject]()
                        diccionario["error"] = "si"
                    }
                }
                print("diccionario : \(diccionario)")

                self.delegateReserva?.didReceiveResponse_reserva(responseObject as! [String : AnyObject])
            },
            failure: {(operation: AFHTTPRequestOperation!, error : NSError!) in
                print("Error \(error.localizedDescription)")
                var diccionario = [String : AnyObject]()
                diccionario["error"] = "si"
                self.delegateReserva?.didReceiveResponse_reserva(diccionario as [String : AnyObject])
            }
        )
    }
    
    // Devuelve una lista de bools que controla que barca se puede reservar
    func mirarPosibleReserva(tipo : Int) {
        var error : NSError?
        
        manager.GET("http://losbarkitos.herokuapp.com/posible_reserva/\(tipo)",
            parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responseObject) in
                
                self.delegateReserva?.didReceiveResponse_reservaPosible(responseObject as! [Bool])
            },
            failure: nil
        )
    }
    
    func salidaBarca(tipo : Int) {
        var error : NSError?
        
        manager.GET("http://losbarkitos.herokuapp.com/salida/\(tipo)",
            parameters: nil,
            success: {(operation : AFHTTPRequestOperation!, responseObject) in
                
                self.delegateControl?.didReceiveResponse_salida(responseObject as! [String : String])
            },
            failure: nil
        )
    }
    
    func llegadaBarca(tipo : Int) {
        
        manager.GET("http://losbarkitos.herokuapp.com/llegada/\(tipo)",
            parameters: nil,
            success: {(operation : AFHTTPRequestOperation!, responseObject) in
                
                self.delegateControl?.didReceiveResponse_llegada(responseObject as! [String : String])
            },
            failure: nil
        )
    }
    
    func barcasFuera() {
        manager.GET("http://losbarkitos.herokuapp.com/fuera",
            parameters: nil,
            success: {(operation : AFHTTPRequestOperation!, responseObject) in
                print(responseObject)
                self.delegateControl?.didReceiveResponse_barcasFuera(responseObject as! [String : [Int]])
            },
            failure: nil)
    }
    
    func siguienteBarcaLlegar() {
        var error : NSError?
        
        manager.GET("http://losbarkitos.herokuapp.com/primera_en_llegar",
            parameters: nil,
            success: {(operation : AFHTTPRequestOperation!, responseObject) in
                self.delegateControl?.didReceiveResponse_siguienteBarcaLlegar(responseObject as! [String : String])
            },
            failure: nil)
        
        
    }
    
    func cierreDia() {
        var error : NSError?
        
        manager.GET("http://losbarkitos.herokuapp.com/cierre_dia",
            parameters: nil,
            success: {(operation : AFHTTPRequestOperation!, responseObject) in
                self.delegate?.didReceiveResponse_cierreDia(responseObject as! String)
            },
            failure: nil)
    }
    
    func salidaReserva(tipo : Int, numero : Int) {
        var error : NSError?
        
        manager.GET("http://losbarkitos.herokuapp.com/reserva_fuera/\(tipo)/\(numero)",
            parameters: nil,
            success: {(operation : AFHTTPRequestOperation!, responseObject) in
                self.delegateControl?.didReceiveResponse_salidaReserva("OK", tipo: tipo)
            },
            failure: {(operation : AFHTTPRequestOperation!, responseObject) in
                self.delegateControl?.didReceiveResponse_salidaReserva("KO", tipo: tipo)
        })
    }
    
    func numeroReservasPorDar() {
        var error : NSError?
        
        manager.GET("http://losbarkitos.herokuapp.com/total_reservas",
            parameters: nil,
            success: {(operation : AFHTTPRequestOperation!, responseObject) in
                self.delegateControl?.didReceiveResponse_reservasPorDar(responseObject as! [String : AnyObject])
            },
            failure: {(operation : AFHTTPRequestOperation!, error) in
                self.delegateControl?.didReceiveResponse_reservasPorDar(responseObject as! [String : AnyObject])
            }
        )
    }
}

