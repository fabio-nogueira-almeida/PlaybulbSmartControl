//
//  File.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 05/06/18.
//  Copyright © 2018 Fábio Nogueira de Almeida. All rights reserved.
//

import Foundation

extension UnicodeScalar {
    var hexNibble: UInt8 {
        let value = self.value
        if 48 <= value && value <= 57 {
            return UInt8(value - 48)
        } else if 65 <= value && value <= 70 {
            return UInt8(value - 55)
        } else if 97 <= value && value <= 102 {
            return UInt8(value - 87)
        }
        fatalError("\(self) not a legal hex nibble")
    }
}
