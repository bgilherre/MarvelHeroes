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
    class func crearSesionRed(url: String, limit:String, offset: String) -> (NSMutableURLRequest, URLSession) {
        
        let request: NSMutableURLRequest
        let session = URLSession.shared
        
        let APIKEY: String = "c0252ec5bc3ee9b2c6a0a26e2dfb306d"
        let PRIVKEY: String = "c124cdc74823164742598e641674842fa2de600c"
        
        let ts = NSDate().timeIntervalSince1970.description
        let hash = "\(ts)\(PRIVKEY)\(APIKEY)".md5()!

        
        let urlFinal: String = url + "?ts=" + ts + "&apikey="  + APIKEY + "&hash=" + hash + "&limit=" + limit + "&offset=" + offset
        
        request = NSMutableURLRequest(url: URL(string: urlFinal)!)
        
        return (request, session)
    }
    
    class func llamadaPersonajes(limit: String, offset: String) -> Bool{
        
        var request: NSMutableURLRequest = NSMutableURLRequest()
        var session: URLSession = URLSession()

        var retorno: Bool = true
        
        (request,session) = crearSesionRed(url : "https://gateway.marvel.com/v1/public/characters", limit: limit, offset: offset)

        semaforo.enter()
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in

            do{
                let result = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)!
                let cadData:String = (result as String)

                //let dataA : Data = cadData.data(using: String.Encoding.utf8)!
                //Transformamos la informacion a un diccionario

                //let dataB : NSDictionary = try JSONSerialization.jsonObject(with: dataA, options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if let jsonData = cadData.data(using: .utf8)
                {
                    let respuestaAPI = try? JSONDecoder().decode(RespuestaAPI.self, from: jsonData)
                    //Only with name, age, gender properties decoded from json as we have defined CodingKeys enum in Person class.
                    //while respuestaAPI == nil{
                   // }
	                    print(respuestaAPI?.data.results[2].name)
                    print(respuestaAPI?.code)
                    

                    //person.phone and person.country will be empty
                
                //Recorremos la informacion que nos devuelve la API de Marvel para llegar a la información
                ///*
                //let code: [Int64] = dataB.objects(forKeys: ["code"], notFoundMarker: self) as! [Int64]
                    if respuestaAPI!.code == 200{
                //if code[0] == 200{
                    //let datos:[NSDictionary]  = dataB.objects(forKeys: ["data"], notFoundMarker: self) as! [NSDictionary]
            
                    //let resultados: [NSArray] = datos.first!.objects(forKeys: ["results"], notFoundMarker: self) as! [NSArray]
                        if respuestaAPI!.data.count != 0{
                    //if resultados.count != 0{
                            if respuestaAPI!.data.results.count != 0{
                        //if resultados[0].count != 0{
                            //crearPersonajes(datos: resultados[0])
                                crearPersonajes(datos: respuestaAPI!.data.results)
                            retorno =  true
                            print("entro2 :" + String(retorno))
                        }else{
                            retorno = false
                        }
                    }else{
                        retorno = false
                    }
                }else{
                    retorno = false
                        print("Codigo de error: " + (respuestaAPI?.code.description)!)
                }
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

    class func crearPersonajes(datos: [CharacterAPI]){

        for item in datos{
            
            let nombre: String = item.name
            let descripcion :String = item.descriptionString
            //let thumbnail = (item as AnyObject).value(forKey: "thumbnail")
            let rutaImagen: String = item.thumbnail.path
            let extensionImagen: String = item.thumbnail.extensionString
            let rutaCompleta: String = rutaImagen + "." + extensionImagen
            //let rutaCompleta: String = rutaImagen + "." + "jpg"
            print(rutaCompleta)
            crearHeroe(nombre: nombre, descripcion: descripcion, imagen: rutaCompleta)
        }


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
