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
    
//    let bluetoothManager: BluetoothManager
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mansion Stronda Lights 😉"
        self.addRefreshBarButtonItem()
    }

    // MARK: - Private
    
    func addRefreshBarButtonItem() {
        let refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                   target: self,
                                                   action: Selector(("refreshAction")))
        self.navigationItem.setRightBarButton(refreshBarButtonItem, animated: true)
    }
    
    func refreshAction() {
        
    }
}

extension ListDevicesViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
    }

}

extension ListDevicesViewController: UITableViewDelegate {
    
}
