//
//  ListDeviceViewController+TableViewProtocols.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 09/06/18.
//  Copyright © 2018 Fábio Nogueira de Almeida. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource

extension ListDevicesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return verifyNumberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRows = model?.count {
            return numberOfRows
        }
        return 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

        if let name = model?.object(at: indexPath.row) as? String? {
            cell.textLabel?.text = name
        }
        
        applyLayout(on: cell)

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
        didSelectedRow(at: indexPath)
    }
}

// MAKR: ListDeviceTableViewLayoutProtocol

extension ListDevicesViewController: ListDeviceTableViewLayoutProtocol {

    internal func tableViewLayout() {
        tableView.backgroundColor = UIColor(named: .dark)
        tableView.tableFooterView = UIView()
    }

    internal func applyLayout(on cell: UITableViewCell) {
        cell.backgroundColor = UIColor(named: .dark)

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(named: .green)
        cell.selectedBackgroundView = bgColorView

        cell.textLabel?.textColor = .white
    }

    internal func presentEmptyMessage(message: String, on tableView: UITableView) {
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

extension ListDevicesViewController: ListDeviceTableViewDataSourceProtocol {
    internal func verifyNumberOfSections() -> Int {
        if model?.count == 0 {
            presentEmptyMessage(message: .emptyMessage,
                                on: tableView)
            return 0
        }
        
        return 1
    }
}

extension ListDevicesViewController: ListDeviceTableViewDelegateProtocol {
    internal func didSelectedRow(at indexPath: IndexPath) {
        guard let peripheralName = model?.object(at: indexPath.row) as? String else {
            changeState(for: .error)
            return
        }
        
        changeState(for: .connecting(peripheralName))
    }
}

fileprivate extension String {
    static let emptyMessage = "parece que estão desligadas \n\n 💡 😭"
}
