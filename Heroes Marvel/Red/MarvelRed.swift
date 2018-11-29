//
//  MarvelRed.swift
//  Heroes Marvel
//
//  Created by Borja Gil Herrero on 28/11/2018.
//  Copyright © 2018 Alsis GHE. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MarvelRed: NSObject{
    static var semaforo: DispatchGroup = DispatchGroup()
    //Funcion que nos genera una sesion de red a partir de una url a la que conectarse
    class func crearSesionRed(url: String, limit:String, offset: String) -> (NSMutableURLRequest, URLSession, String) {
        
        let request: NSMutableURLRequest
        let session = URLSession.shared
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let tiempoIni = formatter.string(from: Date())
        
        let APIKEY: String = "c0252ec5bc3ee9b2c6a0a26e2dfb306d"
        let PRIVKEY: String = "c124cdc74823164742598e641674842fa2de600c"
        
        let ts = NSDate().timeIntervalSince1970.description
        let hash = "\(ts)\(PRIVKEY)\(APIKEY)".md5()!

        
        let urlFinal: String = url + "?ts=" + ts + "&apikey="  + APIKEY + "&hash=" + hash + "&limit=" + limit + "&offset=" + offset
        
        request = NSMutableURLRequest(url: URL(string: urlFinal)!)
        
        return (request, session, tiempoIni)
    }
    
    class func llamadaPersonajes(limit: String, offset: String) -> Bool{
        
        var request: NSMutableURLRequest = NSMutableURLRequest()
        var session: URLSession = URLSession()
        var timeLoad: String
        var retorno: Bool = true
        
        (request,session,timeLoad) = crearSesionRed(url : "https://gateway.marvel.com/v1/public/characters", limit: limit, offset: offset)
        
        semaforo.enter()
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in

            do{
                let result = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)!
                let cadData:String = (result as String)

                let dataA : Data = cadData.data(using: String.Encoding.utf8)!

                let dataB : NSDictionary = try JSONSerialization.jsonObject(with: dataA, options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                //print(dataB)
                
                let datos:[NSDictionary]  = dataB.objects(forKeys: ["data"], notFoundMarker: self) as! [NSDictionary]
        
                let resultados: [NSArray] = datos.first!.objects(forKeys: ["results"], notFoundMarker: self) as! [NSArray]
                
                if resultados.count != 0{
                    crearPersonajes(datos: resultados)
                    retorno =  true
                    print("entro2 :" + String(retorno))
                }else{
                    retorno = false
                }
            }catch{
                print(error)
                semaforo.leave()
            }
            semaforo.leave()
        })
        task.resume()
        semaforo.wait()
        return retorno

    }

    class func crearPersonajes(datos: [NSArray]){
        
        //let store = CoreDataStack.store
        let res = datos[0]
        for item in res{
            
            let nombre: String = (item as AnyObject).value(forKey: "name") as! String
            let descripcion : String = (item as AnyObject).value(forKey: "description") as! String
            let thumbnail = (item as AnyObject).value(forKey: "thumbnail")
            let rutaImagen: String = (thumbnail as AnyObject).value(forKey: "path") as! String
            let extensionImagen: String = (thumbnail as AnyObject).value(forKey: "extension") as! String
            let rutaCompleta: String = rutaImagen + "." + extensionImagen
            
            crearHeroe(nombre: nombre, descripcion: descripcion, imagen: rutaCompleta)
        }
        //store.saveContext()

    }

    class func crearHeroe(nombre:String, descripcion: String, imagen: String){
        let store = CoreDataStack.store
        let heroeEntity = NSEntityDescription.entity(forEntityName: "Heroe", in: store.managedObjectContext)
        
        let heroe = NSManagedObject(entity: heroeEntity!,insertInto: store.managedObjectContext)
        if nombre  != ""{
            heroe.setValue(nombre, forKey: "nombre")
        }
        if descripcion != ""{
            heroe.setValue(descripcion, forKey: "descripcion")
        }
        if imagen != ""{
            let url:NSURL = NSURL(string: imagen)!
            do{
                let data:NSData = try NSData(contentsOf: url as URL)

                heroe.setValue(data, forKey: "imagen")
            }catch{
                
            }
        }
        store.saveContext()
        NSLog("Heroe creado")
    }
}
