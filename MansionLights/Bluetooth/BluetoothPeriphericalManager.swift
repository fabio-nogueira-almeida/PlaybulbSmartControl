//
//  BluetoothPeriphericalManager.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit
import CoreBluetooth

// MARK: Protocol

protocol BluetoothPeriphericalManagerAPIProtocol {
    func powerOnMode()
    func powerOffMode()
    func whiteMode()
    func sexyMode()
    func readMode()
}

protocol BluetoothPeriphericalManagerProtocol {
    func colorCharacteristic() -> CBCharacteristic
    func changeColor(colorHex: String)
}

class BluetoothPeriphericalManager: NSObject {

    // MARK: - Constants

    let colorCharacteristicUIID = "FFFC"

    // MARK: - Properties

    var peripherical: CBPeripheral
    var characteristics: NSMutableArray = []

    // MARK: - Initialize

    init(peripherical: CBPeripheral) {
        self.peripherical = peripherical
    }

    // MARK: - Public

    func setup() {
        self.peripherical.delegate = self
        self.peripherical.discoverServices(nil)
    }
}

// MARK: CBPeripheralDelegate

extension BluetoothPeriphericalManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            peripheral.discoverCharacteristics(nil, for: thisService)
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        for characteristic in service.characteristics! {
            self.characteristics.add(characteristic)
        }
    }
}

// MARK: BluetoothPeriphericalManagerAPIProtocol

extension BluetoothPeriphericalManager: BluetoothPeriphericalManagerAPIProtocol {
    func powerOnMode() {
        changeColor(colorHex: "ff000000")
    }

    func powerOffMode() {
        changeColor(colorHex: "00000000")
    }

    func whiteMode() {
        changeColor(colorHex: "88FFFFFF")
    }
    
    func sexyMode() {
        changeColor(colorHex: "00ff0000")
    }
    
    func readMode() {
        changeColor(colorHex: "26000000")
    }
}

// MARK: BluetoothPeriphericalManagerProtocol

extension BluetoothPeriphericalManager: BluetoothPeriphericalManagerProtocol {
    func colorCharacteristic() -> CBCharacteristic {
        let array = self.characteristics as? [CBCharacteristic]
        // TODO: Add Loading
        // TODO: Add guard statement
        return (array!.filter {$0.uuid == CBUUID(string: colorCharacteristicUIID)}.first)!
    }

    func changeColor(colorHex: String) {
        self.peripherical.writeValue(Data(hex: colorHex),
                                     for: self.colorCharacteristic(),
                                     type: .withoutResponse)
    }

}
