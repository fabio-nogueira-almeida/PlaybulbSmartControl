//
//  BluetoothManager.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol BluetoothManagerDelegate {
    func managerDidFoundDevices(devicesNames: NSArray)
}

protocol BluetoothManagerPeripheralDelegate {
    
}

class BluetoothManager: NSObject {

    // MARK: - Constants
    let serviceUIID = "FF0D"
    let colorCharacteristicUIID = "FFFC"

    // MARK: - Properties
    var manager: CBCentralManager
    var delegate: BluetoothManagerDelegate?
    var peripherals: NSMutableArray = []
    var characteristics: [CBCharacteristic]?


    // MARK: - Initialize
    override init() {
        self.manager = CBCentralManager(delegate: nil,
                                               queue: nil)
        super.init()
        self.manager.delegate = self
    }

    // MARK: - Public
    func startSearchDevices() {
        self.cleanPeripherals()
        self.manager.scanForPeripherals(withServices: [CBUUID(string: serviceUIID)],
                                               options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.stopSearchPeripherals()
        }
    }

    // MARK: - Private
    private func cleanPeripherals() {
        self.peripherals = []
    }

    private func stopSearchPeripherals() {
        self.manager.stopScan()
        guard let peripherals = self.peripherals as? Array<CBPeripheral> else {
            return
        }

        let devicesNames = peripherals.map {$0.name}
        self.delegate?.managerDidFoundDevices(devicesNames: devicesNames as NSArray)
    }
}

    // MARK: - CBCentralManagerDelegate
extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {

        case .poweredOff:
            print("BLE Powered OFF")

        case .poweredOn:
            print("BLE Powered ON")
            self.startSearchDevices()

        case .resetting:
            print("BLE Resetting")

        case .unauthorized:
            print("BEL Not Authorized")

        case .unknown:
            print("Unknow BLE")

        default:
            print("not supported")
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        self.peripherals.add(peripheral)
    }

    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
}

extension BluetoothManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        if let characteristics = service.characteristics {
            self.characteristics = characteristics
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverIncludedServicesFor service: CBService,
                    error: Error?) {
        self.manager.scanForPeripherals(withServices: [CBUUID(string: serviceUIID)],
                                               options: nil)
    }

}
//
//                let peripheral = self.peripherals.firstObject as! CBPeripheral
//                peripheral.delegate = self
//                self.centralManager?.connect(peripheral,
//                                             options: nil)
//
//                let data = Data(base64Encoded: "")
//                peripheral.writeValue(<#T##data: Data##Data#>, for: , type: .withoutResponse)
//if thisCharacteristic.uuid == CBUUID(string: colorCharacteristicUIID) {
//    peripheral.writeValue(Data(hex: "0000dd00"),
//                          for: thisCharacteristic,
//                          type: .withoutResponse)
//}
