//
//  BluetoothPeriphericalManager.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol BluetoothPeriphericalManagerAPIProtocol {
    func powerOn()
    func powerOff()
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
    func powerOn() {
        changeColor(colorHex: UIColor.white.hex)
    }

    func powerOff() {
        changeColor(colorHex: UIColor.black.hex)
    }
}

// MARK: BluetoothPeriphericalManagerProtocol

extension BluetoothPeriphericalManager: BluetoothPeriphericalManagerProtocol {
    func colorCharacteristic() -> CBCharacteristic {
        let array = self.characteristics as? [CBCharacteristic]
        return (array!.filter {$0.uuid == CBUUID(string: colorCharacteristicUIID)}.first)!
    }

    func changeColor(colorHex: String) {
        self.peripherical.writeValue(Data(hex: colorHex),
                                     for: self.colorCharacteristic(),
                                     type: .withoutResponse)
    }

}
