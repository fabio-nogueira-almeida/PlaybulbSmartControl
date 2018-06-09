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
    func desligarAction()
    func ligarAction()
}

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
        self.view.backgroundColor = UIColor.white
    }
}

// MARK: DeviceActionsProtocol

extension DeviceViewController: DeviceActionsProtocol {
    @objc internal func goToInitialScreen() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc internal func desligarAction() {
        self.bluetoothPeriphericalManager?.powerOff()
    }

    @objc internal func ligarAction() {
        self.bluetoothPeriphericalManager?.powerOn()
    }
}
