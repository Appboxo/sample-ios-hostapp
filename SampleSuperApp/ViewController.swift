//
//  ViewController.swift
//  SampleSuperApp
//
//  Created by azamat on 4/29/20.
//  Copyright © 2020 azamat. All rights reserved.
//

import UIKit
import AppBoxoSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        AppBoxo.shared.setConfig(config: Config(clientId: "client_id"))
    }

    @IBAction func openMiniapp(_ sender: Any) {
        guard let miniApp = AppBoxo.shared.createMiniApp(appId: "app_od",
                                                         payload: "payload") else { return }
        //miniApp.delegate = self
        miniApp.open(navigationController: navigationController!)
    }
    
}

