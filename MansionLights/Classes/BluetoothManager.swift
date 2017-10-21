//
//  BluetoothManager.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothManager: NSObject {

// MARK: - Properties

    var centralManager: CBCentralManager!
    var peripherals: NSMutableArray = []

}

// MARK: - CBCentralManagerDelegate

extension BluetoothManager: CBCentralManagerDelegate {
   
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)

        switch central.state {

        case .poweredOff:
            print("BLE Powered OFF")

        case .poweredOn:
            print("BLE Powered ON")
            central.scanForPeripherals(withServices: [CBUUID(string: "FF0D")],
                                       options: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.centralManager?.stopScan()


                let peripheral = self.peripherals.firstObject as! CBPeripheral
                peripheral.delegate = self
                self.centralManager?.connect(peripheral,
                                             options: nil)

                //                let data = Data(base64Encoded: "")
                //                peripheral.writeValue(<#T##data: Data##Data#>, for: , type: .withoutResponse)
                
            }

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
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        self.peripherals.add(peripheral)
    }

    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {

    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        //        peripheral.writeValue(<#T##data: Data##Data#>, for: <#T##CBCharacteristic#>, type: <#T##CBCharacteristicWriteType#>)
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            
            //            if service.UUID == BEAN_SERVICE_UUID {
            peripheral.discoverCharacteristics(nil, for: thisService)
            //            }
        }
    }
}

extension BluetoothManager: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            //            print(thisCharacteristic)
            
            if thisCharacteristic.uuid == CBUUID(string: "FFFC") {
                peripheral.writeValue(Data(hex: "0000dd00"),
                                      for: thisCharacteristic,
                                      type: .withoutResponse)
            }
            
            //            if thisCharacteristic.UUID == BEAN_SCRATCH_UUID {
            //                self.peripheral.setNotifyValue(
            //                    true,
            //                    forCharacteristic: thisCharacteristic
            //                )
            //            }
            //        }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        self.centralManager.scanForPeripherals(withServices: [CBUUID(string: "FF0D")],
                                               options: nil)
    }

}


