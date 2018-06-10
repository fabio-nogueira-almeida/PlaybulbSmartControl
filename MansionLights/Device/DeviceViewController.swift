//
//  DeviceViewController.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol DeviceLayoutProtocol {
    func addViewLayout()
    func addBackBarButtonItem()
}

protocol DeviceActionsProtocol {
    func goToInitialScreen()
    func turnOff()
    func turnOn()
}

// TODO: Add datasource with lines of options,
// TODO: turn on,
// TODO: turn off,
// TODO: red color,
// TODO: read color,
// TODO: opacity

class DeviceViewController: UIViewController {

    // MARK: Properties

    var bluetoothPeriphericalManager: BluetoothPeriphericalManager?

    // MARK: - Initialize

    func setup(peripherical: CBPeripheral) {
        self.bluetoothPeriphericalManager =
            BluetoothPeriphericalManager(peripherical: peripherical)
        self.bluetoothPeriphericalManager?.setup()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        turnOn()
    }
}

// MARK: DeviceLayoutProtocol

extension DeviceViewController: DeviceLayoutProtocol {
    internal func addBackBarButtonItem() {
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "ARROW ICON"),
                                                style: .plain,
                                                target: self,
                                            action: #selector(self.goToInitialScreen))
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }

    internal func addViewLayout() {
        addBackBarButtonItem()
        self.view.backgroundColor = UIColor.white
    }
}

// MARK: DeviceActionsProtocol

extension DeviceViewController: DeviceActionsProtocol {
    @objc internal func goToInitialScreen() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc internal func turnOff() {
        self.bluetoothPeriphericalManager?.powerOff()
    }

    @objc internal func turnOn() {
        self.bluetoothPeriphericalManager?.powerOn()
    }
}
