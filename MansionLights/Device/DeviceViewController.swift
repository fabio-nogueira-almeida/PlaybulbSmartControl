//
//  DeviceViewController.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit
import CoreBluetooth

// MARK: Protocols

protocol TableViewConfiguration {
    func tableViewProtocol()
    func tableViewLayout()
    func applyLayout(on cell: UITableViewCell)
}

protocol DeviceLayoutProtocol {
    func addViewLayout()
    func addBackBarButtonItem()
}

protocol DeviceActionsProtocol {
    func goToInitialScreen()
}

enum State: CaseIterable {
    case On
    case Off
    case White
    case Sexy
    case Reading
    
    func title() -> String {
        switch self {
        case .On:
            return .turnOn
            
        case .Off:
            return .turnOff
            
        case .White:
            return .white
            
        case .Sexy:
            return .sexy
            
        case .Reading:
            return .reading
        }
    }
    
    func action(on peripherical: BluetoothPeriphericalManager) {
        switch self {
        case .On:
            peripherical.powerOnMode()
            
        case .Off:
            peripherical.powerOffMode()

        case .White:
            peripherical.whiteMode()
            
        case .Sexy:
            peripherical.sexyMode()
            
        case .Reading:
            peripherical.readMode()
        }
    }
}

final class DeviceViewController: UITableViewController {

    // MARK: Properties

    internal var bluetoothPeriphericalManager: BluetoothPeriphericalManager?

    // MARK: - Initialize

    func setup(peripherical: CBPeripheral) {
        self.bluetoothPeriphericalManager =
            BluetoothPeriphericalManager(peripherical: peripherical)
        self.bluetoothPeriphericalManager?.setup()
        self.title = peripherical.name! + " 💡"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewLayout()
        tableViewProtocol()
        tableViewLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // TODO: Desabilitar lampada
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
}

// MARK: UITableViewConfiguration

extension DeviceViewController: TableViewConfiguration {
    internal func tableViewProtocol() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    internal func tableViewLayout() {
        self.tableView.backgroundColor = UIColor(named: .dark)
    }
    
    
    internal func applyLayout(on cell: UITableViewCell) {
        cell.backgroundColor = UIColor(named: .dark)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(named: .purple)
        cell.selectedBackgroundView = bgColorView
        
        cell.textLabel?.textColor = .white
    }
}

extension String {
    static let turnOn = "Acender"
    static let turnOff = "Apagar"
    static let white = "Branca"
    static let sexy = "Sexo"
    static let reading = "Leitura"
}
