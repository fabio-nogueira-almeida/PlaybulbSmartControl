//
//  ListDevicesViewController.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit
import CoreBluetooth

// MARK: Protocols

protocol ListDeviceTableViewDataSourceProtocol {
    func verifyNumberOfSections() -> Int
}

protocol ListDeviceTableViewLayoutProtocol {
    func tableViewLayoutConfiguration()
    func applyLayout(on cell: UITableViewCell)
    func presentEmptyMessage(message: String, on tableView: UITableView)
}

protocol ListDeviceLayoutProtocol {
    func viewLayoutConfiguration()
}

protocol ListDeviceNavigatorProtocol {
    func presentDeviceViewController(peripherical: CBPeripheral)
}

protocol ListDevicesActionsProtocol {
    func startRefreshAction()
    func stopRefreshAction()
}

class ListDevicesViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    let bluetoothManager = BluetoothManager()
    var model: NSArray?

    // MARK: - Properties Lazy

    private lazy var refreshBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh,
                               target: self,
                               action: #selector(self.startRefreshAction))
    }

    private lazy var refreshIndicatorView = { () -> UIActivityIndicatorView in
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView.startAnimating()
        return indicatorView
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewLayoutConfiguration()
        viewLayoutConfiguration()
        addProtocols()
        addRefreshBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        bluetoothManager.desconnect()
        tableView.reloadData()
        startRefreshAction()
    }

    // MARK: - Private

    private func addProtocols() {
        bluetoothManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func addRefreshBarButtonItem() {
        navigationItem.setRightBarButton(refreshBarButtonItem(),
                                              animated: true)
    }
}

// MARK: ListDeviceLayoutProtocol

extension ListDevicesViewController: ListDeviceLayoutProtocol {
    internal func viewLayoutConfiguration() {
        title = "Lampadas 💡"
        view.backgroundColor = UIColor(named: "Dark")
    }
}

// MARK: ListDeviceNavigatorProtocol

extension ListDevicesViewController: ListDeviceNavigatorProtocol {
    internal func presentDeviceViewController(peripherical: CBPeripheral) {
        let viewController = DeviceViewController()
        viewController.setup(peripherical: peripherical)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: ListDevicesActionsProtocol

extension ListDevicesViewController: ListDevicesActionsProtocol {
    @objc internal func startRefreshAction() {
        bluetoothManager.startSearchDevices()
        navigationItem.rightBarButtonItem?.customView = refreshIndicatorView()
    }

    internal func stopRefreshAction() {
        addRefreshBarButtonItem()
    }
}
