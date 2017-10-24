//
//  ListDevicesViewController.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 21/10/17.
//  Copyright © 2017 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit

class ListDevicesViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    private let bluetoothManager = BluetoothManager()
    private var devicesName: NSArray?

    // MARK: - Properties Lazy

    lazy var refreshBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh,
                               target: self,
                               action: #selector(self.startRefreshAction))
    }

    lazy var refreshIndicatorView = { () -> UIActivityIndicatorView in
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView.startAnimating()
        return indicatorView
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addRefreshBarButtonItem()
        self.tableViewLayoutConfiguration()
        self.viewLayoutConfiguration()
        self.addProtocols()
    }

    override func viewDidAppear(_ animated: Bool) {
        startRefreshAction()
    }

    // MARK: - Private

    private func viewLayoutConfiguration() {
        self.title = "Lampadas 💡"
        self.view.backgroundColor = UIColor(named: "Dark")
    }

    private func tableViewLayoutConfiguration() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor(named: "Dark")
        self.tableView.tableFooterView = UIView()
    }

    private func addProtocols() {
        self.bluetoothManager.delegate = self
    }

    private func addRefreshBarButtonItem() {
        self.navigationItem.setRightBarButton(self.refreshBarButtonItem(),
                                              animated: true)
    }

    // MARK: - Actions

    @objc func startRefreshAction() {
        self.bluetoothManager.startSearchDevices()
        self.navigationItem.rightBarButtonItem?.customView = self.refreshIndicatorView()
    }

    func stopRefreshAction() {
        self.addRefreshBarButtonItem()
    }
}

    // MARK: - Private TableView
extension ListDevicesViewController {
    private func cellLayoutConfiguration(_ cell: UITableViewCell) {
        cell.backgroundColor = UIColor(named: "Dark")

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(named: "Green")
        cell.selectedBackgroundView = bgColorView

        cell.textLabel?.textColor = .white
    }

    func emptyMessage(message: String,
                      tableView: UITableView) {
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: tableView.bounds.size.width,
                                                 height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 24)

        tableView.backgroundView = messageLabel
    }
}

// MARK: - UITableViewDataSource
extension ListDevicesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSection = 1
        if (self.devicesName == nil) &&
            (self.devicesName?.count == 0) {
            emptyMessage(message: "parece que elas estao desligadas \n\n 💡 😭",
                         tableView: tableView)
            numberOfSection = 0
        }

        return numberOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRows = self.devicesName?.count {
            return numberOfRows
        }
        return 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if let name = self.devicesName?.object(at: indexPath.row) as? String? {
            cell.textLabel?.text = name
        }
        self.cellLayoutConfiguration(cell)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITableViewDelegate
extension ListDevicesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if let name = self.devicesName?.object(at: indexPath.row) as? String? {
            let peripherical = self.bluetoothManager.connect(name!)
            let viewController = DeviceViewController()
            viewController.setup(peripherical: peripherical!)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

    // MARK: - BluetoothManagerDelegate
extension ListDevicesViewController: BluetoothManagerDelegate {
    func managerDidFoundDevices(devicesNames: NSArray) {
        self.devicesName = devicesNames
        self.tableView.reloadData()
        self.stopRefreshAction()
    }
}
