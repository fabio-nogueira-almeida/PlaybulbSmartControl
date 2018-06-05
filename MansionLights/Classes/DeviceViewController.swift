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

    // MARK: Private

    private func addBackBarButtonItem() {
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "ARROW ICON"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(self.popViewController))
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }

    private func addViewLayout() {
        self.view.backgroundColor = UIColor.white
    }

    // MARK: Actions

    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func desligarAction() {
        self.bluetoothPeriphericalManager?.powerOff()
    }

    @objc func ligarAction() {
        self.bluetoothPeriphericalManager?.powerOn()
    }
}
