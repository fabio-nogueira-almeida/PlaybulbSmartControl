//
//  DeviceViewController.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceViewController: UIViewController {

    // MARK: Properties
    var bluetoothPeriphericalManager: BluetoothPeriphericalManager?

    // MARK - Initialize
    func setup(peripherical: CBPeripheral) {
        self.bluetoothPeriphericalManager =
            BluetoothPeriphericalManager(peripherical: peripherical)
        self.bluetoothPeriphericalManager?.setup()
    }
    
    // MARK - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "ARROW ICON"),
                                                style: .plain,
                                                target: nil,
                                                action: nil)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        
        self.view.backgroundColor = UIColor.white
        
        let desligarButton = UIButton(type: .system)
        desligarButton.frame = CGRect(x: 10, y: 100, width: 100, height: 100)
        desligarButton.setTitle("Desligar", for: .normal)
        desligarButton.addTarget(self, action: #selector(desligarAction), for: .touchUpInside)
        self.view.addSubview(desligarButton)
        
        let ligarButton = UIButton(type: .system)
        ligarButton.frame = CGRect(x: 10, y: 200, width: 100, height: 100)
        ligarButton.setTitle("Ligar", for: .normal)
        ligarButton.addTarget(self, action: #selector(ligarAction), for: .touchUpInside)
        self.view.addSubview(ligarButton)
    }
    
    @objc func desligarAction() {
        self.bluetoothPeriphericalManager?.powerOff()
    }
    
    @objc func ligarAction() {
        self.bluetoothPeriphericalManager?.powerOn()
    }
}
