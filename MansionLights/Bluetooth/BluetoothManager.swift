//
//  BluetoothManager.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol BluetoothManagerDelegate: class {
    func managerDidFoundDevices(devicesNames: NSArray)
}

class BluetoothManager: NSObject {

    // MARK: - Properties
    
    var manager: CBCentralManager
    weak var delegate: BluetoothManagerDelegate?
    var peripherals: NSMutableArray = []
    var peripheralConnected: CBPeripheral?

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
        self.manager.scanForPeripherals(withServices: [CBUUID(string: .serviceUIID)],
                                               options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.stopSearchPeripherals()
        }
    }

    func connect(_ name: String) -> CBPeripheral {

        guard let peripherals = self.peripherals as? Array<CBPeripheral>,
            let peripheral = (peripherals.filter {$0.name == name}.first) else{
            fatalError("no peripheral founded")
        }
        
        self.manager.connect(peripheral,
                             options: nil)
        self.peripheralConnected = peripheral
        return peripheral
    }

    func desconnect() {
        if let peripheral = self.peripheralConnected {
            self.manager.cancelPeripheralConnection(peripheral)
            self.peripheralConnected = nil
        }
    }

    // MARK: - Private
    
    private func cleanPeripherals() {
        self.peripherals = []
    }

    private func stopSearchPeripherals() {
        self.manager.stopScan()
        self.sendDevicesNamesToDelegator()
    }

    private func sendDevicesNamesToDelegator() {
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
        if !self.peripherals.contains(peripheral) {
            self.peripherals.add(peripheral)
        }
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

fileprivate extension String {
    static let serviceUIID = "FF0D"
}
