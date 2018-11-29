//
//  StringExtension.swift
//  Heroes Marvel
//
//  Created by Borja Gil Herrero on 29/11/2018.
//  Copyright © 2018 Alsis GHE. All rights reserved.
//

import Foundation
import CommonCrypto

extension String{
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
