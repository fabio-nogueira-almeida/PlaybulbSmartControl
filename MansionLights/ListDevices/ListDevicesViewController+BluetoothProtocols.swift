//
//  ListDevicesViewController+BluetoothProtocols.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 09/06/18.
//  Copyright © 2018 Fábio Nogueira de Almeida. All rights reserved.
//

import Foundation

// MARK: - BluetoothManagerDelegate

extension ListDevicesViewController: BluetoothManagerDelegate {
    func managerDidFoundDevices(devicesNames: NSArray) {
        changeState(for: .searched(devicesNames))
    }
}
