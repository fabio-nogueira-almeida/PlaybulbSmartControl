//
//  ListDevicesViewController.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit

class ListDevicesViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    let bluetoothManager = BluetoothManager()
    var devicesName: NSArray?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRefreshBarButtonItem()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.bluetoothManager.delegate = self
        self.title = "Mansion Stronda Lights 😉"
    }

    override func viewDidAppear(_ animated: Bool) {
        self.bluetoothManager.startSearchDevices()
    }

    // MARK: - Private
    func addRefreshBarButtonItem() {
        let refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                   target: self,
                                                   action: #selector(refreshAction))
        self.navigationItem.setRightBarButton(refreshBarButtonItem, animated: true)
    }

    @objc func refreshAction() {
        self.bluetoothManager.startSearchDevices()
    }
}

extension ListDevicesViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        if let count = self.devicesName?.count {
            return count
        }
        return 0
    }

    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if let name = self.devicesName?.object(at: indexPath.row) as? String? {
            cell.textLabel?.text = name
        }

        return cell
    }
}

extension ListDevicesViewController: UITableViewDelegate {
}

extension ListDevicesViewController: BluetoothManagerDelegate {
    func managerDidFoundDevices(devicesNames: NSArray) {
        self.devicesName = devicesNames
        self.tableView.reloadData()
    }
}
