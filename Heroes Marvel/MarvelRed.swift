//
//  MarvelRed.swift
//  Heroes Marvel
//
//  Created by Borja Gil Herrero on 28/11/2018.
//  Copyright © 2018 Alsis GHE. All rights reserved.
//

import Foundation

class MarvelRed: NSObject{

    class func crearSesionRed() -> (NSMutableURLRequest, URLSession, String) {
        
        let request: NSMutableURLRequest
        let session = URLSession.shared
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let tiempoIni = formatter.string(from: Date())
        request = NSMutableURLRequest(url: URL(string: "")!)
        
        return (request, session, tiempoIni)
    }


}
