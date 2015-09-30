//
//  listadoVentasViewController.swift
//  LosBarkitosIpad
//
//  Created by Jesus Valladolid Rebollar on 15/7/15.
//  Copyright (c) 2015 Jesus Valladolid Rebollar. All rights reserved.
//

import UIKit

class listadoVentasViewController: UIViewController, WebServiceListado, UITableViewDataSource, UITableViewDelegate {
    
    var webService : webServiceCallAPI = webServiceCallAPI()
    var listadoBarcas = [[String : AnyObject]]()
    var numeroBarcas : Int = 0
    
    @IBOutlet weak var listadoVentasTableView: UITableView!
    @IBOutlet weak var anteriorUIButton: UIButton!
    
    @IBOutlet weak var totalBarcasUILabel: UILabel!
    
    @IBAction func anteriorPushButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webService.delegateListado = self
        
        webService.obtenerVentas()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func didReceiveResponse_listadoVentas(diccionario : [String : AnyObject]) {
        
        // println("diccionario : \(diccionario)")
        self.listadoBarcas = []
        var registro : [String : AnyObject] = [:]
        print("diccionario : \(diccionario)", terminator: "")
        for (k,v) in diccionario {
            if k == "numero_viajes" {
                self.numeroBarcas = v as! Int
            } else if (k == "error" && v as! String == "si") {
                print("FALLO", terminator: "")
            } else {
                registro["numero"] = v["numero"] as! Int
                registro["punto_venta"] = v["punto_venta"] as! String
                registro["hora"] = v["fecha"] as! String
                registro["precio"] = v["precio"] as! Int
                registro["tipo"] = v["tipo"]
                self.listadoBarcas.append(registro)
            }
        }
        // ordenacion de las reservas por el numero
        
        self.listadoBarcas.sortInPlace({(primero : [String:AnyObject], segundo : [String:AnyObject]) -> Bool in
            return   segundo["hora"] as! String > primero["hora"] as! String
        })
        
        self.listadoVentasTableView.clearsContextBeforeDrawing = true
        self.listadoVentasTableView.reloadData()
        self.totalBarcasUILabel.text =  String(self.numeroBarcas)
        
    }
    
    // IMPLEMENTO LOS METODOS DELEGADOS DE listaUITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.numeroBarcas
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell : listadoVentasTableViewCell = self.listadoVentasTableView.dequeueReusableCellWithIdentifier("CellListadoVentas") as! listadoVentasTableViewCell
        
        let numero : Int = self.listadoBarcas[indexPath.row]["numero"] as! Int
        cell.numeroUILabel.text = String(numero)
        cell.puntoVentaUILabel.text = self.listadoBarcas[indexPath.row]["punto_venta"] as? String
        cell.horaUILabel.text = self.listadoBarcas[indexPath.row]["hora"] as? String
        cell.tipoBarcaUILabel.text = self.listadoBarcas[indexPath.row]["tipo"] as? String
        cell.precioUILabel.text = String(self.listadoBarcas[indexPath.row]["precio"] as! Int)
        
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueListadoVentas" {
            let siguienteVC : VentaViewController = segue.destinationViewController as! VentaViewController
            siguienteVC.tovueltaListadoVentas = true
            siguienteVC.toPreciosViewController = 0
        }
    }

}
