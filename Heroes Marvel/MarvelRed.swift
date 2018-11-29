//
//  MarvelRed.swift
//  Heroes Marvel
//
//  Created by Borja Gil Herrero on 28/11/2018.
//  Copyright © 2018 Alsis GHE. All rights reserved.
//

import Foundation
import CommonCrypto
import CoreData
import UIKit

public enum HashOutputType {
    // standard hex string output
    case hex
    // base 64 encoded string output
    case base64
}

// Defines types of hash algorithms available
public enum HashType {
    case md5
    case sha1
    case sha224
    case sha256
    case sha384
    case sha512
    
    var length: Int32 {
        switch self {
        case .md5: return CC_MD5_DIGEST_LENGTH
        case .sha1: return CC_SHA1_DIGEST_LENGTH
        case .sha224: return CC_SHA224_DIGEST_LENGTH
        case .sha256: return CC_SHA256_DIGEST_LENGTH
        case .sha384: return CC_SHA384_DIGEST_LENGTH
        case .sha512: return CC_SHA512_DIGEST_LENGTH
        }
    }
}

class MarvelRed: NSObject{
    //Funcion que nos genera una sesion de red a partir de una url a la que conectarse
    class func crearSesionRed(url: String) -> (NSMutableURLRequest, URLSession, String) {
        
        let request: NSMutableURLRequest
        let session = URLSession.shared
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let tiempoIni = formatter.string(from: Date())
        
        let APIKEY: String = "c0252ec5bc3ee9b2c6a0a26e2dfb306d"
        let PRIVKEY: String = "c124cdc74823164742598e641674842fa2de600c"
        
        let ts = NSDate().timeIntervalSince1970.description
        let hash = "\(ts)\(PRIVKEY)\(APIKEY)".md5()!

        
        let urlFinal: String = url + "?ts=" + ts + "&apikey="  + APIKEY + "&hash=" + hash
        
        request = NSMutableURLRequest(url: URL(string: urlFinal)!)
        
        return (request, session, tiempoIni)
    }
    
    class func llamadaPersonajes(){
        
        var request: NSMutableURLRequest = NSMutableURLRequest()
        var session: URLSession = URLSession()
        var timeLoad: String        
        
        (request,session,timeLoad) = crearSesionRed(url : "https://gateway.marvel.com/v1/public/characters")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print(data)

            do{
                let result = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)!
                var cadData:String = (result as String)

                let dataA : Data = cadData.data(using: String.Encoding.utf8)!

                let dataB : NSDictionary = try JSONSerialization.jsonObject(with: dataA, options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                //print(dataB)
                
                let datos:[NSDictionary]  = dataB.objects(forKeys: ["data"], notFoundMarker: self) as! [NSDictionary]
                let resultados: [NSArray] = datos.first?.objects(forKeys: ["results"], notFoundMarker: self) as! [NSArray]
                let store = CoreDataStack.store
                let res = resultados[0]
                for item in res{
                    //print(item)
                    print((item as AnyObject).value(forKey: "id")!)
                    print((item as AnyObject).value(forKey: "name")!)
                    print((item as AnyObject).value(forKey: "description")!)
                    //print((item as AnyObject).value(forKey: "thumbnail")!)
                    let thumbnail = (item as AnyObject).value(forKey: "thumbnail")
                    let rutaImagen: String = (thumbnail as AnyObject).value(forKey: "path") as! String
                    let extensionImagen: String = (thumbnail as AnyObject).value(forKey: "extension") as! String
                    let rutaCompleta: String = rutaImagen + "." + extensionImagen
                    
                    let heroeEntity = NSEntityDescription.entity(forEntityName: "Heroe", in: store.persistentContainer.viewContext)
                    
                    let heroe = NSManagedObject(entity: heroeEntity!,insertInto: store.persistentContainer.viewContext)
                    if (item as AnyObject).value(forKey: "name") as! String != ""{
                        heroe.setValue((item as AnyObject).value(forKey: "name")!, forKey: "nombre")
                    }
                    if (item as AnyObject).value(forKey: "description") as! String != ""{
                        heroe.setValue((item as AnyObject).value(forKey: "description")!, forKey: "descripcion")
                    }
                    if rutaCompleta != ""{
                        let url:NSURL = NSURL(string: rutaCompleta)!
                        let data:NSData = try NSData(contentsOf: url as URL)
                        
                        let _: UIImage = UIImage.init(data: data as Data)!
                        print(rutaCompleta)
                        
                        heroe.setValue(data, forKey: "imagen")

                    }
                    
                    NSLog("Heroe creado")
                    print("-------------------------------------------------")
                }

                store.saveContext()
                
            }catch{
                print(error)
            }
        })
        task.resume()


    }

 


}

extension String {
    //Funcion para obtener un hash md5 a partir de una cadena de texto
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        return String(format: hash as String)
    }
}
