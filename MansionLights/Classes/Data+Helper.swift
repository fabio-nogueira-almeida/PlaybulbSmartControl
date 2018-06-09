//
//  Daa+Helper.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 05/06/18.
//  Copyright © 2018 Fábio Nogueira de Almeida. All rights reserved.
//

import Foundation

extension Data {
    init(hex: String) {
        let scalars = hex.unicodeScalars
        var bytes = Array<UInt8>(repeating: 0, count: (scalars.count + 1) >> 1)
        for (index, scalar) in scalars.enumerated() {
            var nibble = scalar.hexNibble
            if index & 1 == 0 {
                nibble <<= 4
            }
            bytes[index >> 1] |= nibble
        }
        self = Data(bytes: bytes)
    }
}
