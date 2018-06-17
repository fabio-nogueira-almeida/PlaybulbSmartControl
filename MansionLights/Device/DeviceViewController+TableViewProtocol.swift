
//
//  DeviceViewController+TableViewProtociol.swift
//  MansionLights
//
//  Created by Fábio Nogueira de Almeida on 17/06/18.
//  Copyright © 2018 Fábio Nogueira de Almeida. All rights reserved.
//

import Foundation
import UIKit

// MARK: UITableViewDelegate

extension DeviceViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return State.allCases.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = State.allCases[indexPath.row].title()
        
        applyLayout(on: cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: UITableViewDelegate

extension DeviceViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        State.allCases[indexPath.row].action(on: bluetoothPeriphericalManager!)
    }
}
