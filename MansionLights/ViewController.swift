//
//  ViewController.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 18/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK: - Properties
    
    var centralManager: CBCentralManager!
    var peripherals: NSMutableArray = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.centralManager = CBCentralManager(delegate: self,
                                               queue: nil,
                                               options: nil)
    }
    
    // MARK: Private 
    
    
    
    // MARK: - CBCentralManagerDelegate
    
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

    @IBAction func buttonAction(_ sender: Any) {
//        FFFC
//        self.peripheral.writeValue(<#T##data: Data##Data#>, for: <#T##CBCharacteristic#>, type: <#T##CBCharacteristicWriteType#>)
    }
}


extension UnicodeScalar {
    var hexNibble:UInt8 {
        let value = self.value
        if 48 <= value && value <= 57 {
            return UInt8(value - 48)
        }
        else if 65 <= value && value <= 70 {
            return UInt8(value - 55)
        }
        else if 97 <= value && value <= 102 {
            return UInt8(value - 87)
        }
        fatalError("\(self) not a legal hex nibble")
    }
}

extension Data {
    init(hex:String) {
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

