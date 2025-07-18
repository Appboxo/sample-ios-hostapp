//
//  TableViewController.swift
//  SampleHostApp
//
//  Created by Azamat Kushmanov on 10/4/25.
//

import UIKit
import BoxoSDK

class TableViewController: UITableViewController {

    var miniapps = [MiniappData]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Miniapps"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UINib(nibName: "MiniappCell", bundle: nil), forCellReuseIdentifier: "MiniappCell")
        tableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(getMiniapps), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        getMiniapps()
    }
    
    @objc func getMiniapps() {
        Boxo.shared.getMiniapps { [weak self] miniapps, error in
            guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
            
            if let error = error {
                showAlert(title: "Error", message: error)
                return
            }
            
            self.miniapps = miniapps
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if miniapps.isEmpty {
            let noDataLabel = UILabel()
            noDataLabel.text = "No miniapps"
            noDataLabel.textColor = .lightGray
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
        } else {
            tableView.backgroundView = nil
        }
        
        return miniapps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiniappCell", for: indexPath) as! MiniappCell

        cell.logoImageView.loadImage(miniapps[indexPath.row].logo ?? "")
        cell.nameLabel.text = miniapps[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let appId = miniapps[indexPath.row].appId else { return }
        
        let miniapp = Boxo.shared.getMiniapp(appId: appId)
        miniapp.delegate = self
        miniapp.open(viewController: self)
    }
}

extension TableViewController: MiniappDelegate {
    func onAuth(miniapp: Miniapp) {
        miniapp.setAuthCode(authCode: "AUTH_CODE")
    }
    
    func didReceiveCustomEvent(miniapp: Miniapp, customEvent: CustomEvent) {
        print("Handle custom event")
    }
    
    func didReceivePaymentEvent(miniapp: Miniapp, paymentData: PaymentData) {
        print("Handle payment event")
    }
}
