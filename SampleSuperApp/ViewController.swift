//
//  ViewController.swift
//  SampleSuperApp
//
//  Created by azamat on 4/29/20.
//  Copyright © 2020 azamat. All rights reserved.
//

import UIKit
import UserNotifications
import AppBoxoSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification), name: .onPushNotificationTapped, object: nil)
        
        AppBoxo.shared.setConfig(config: Config(clientId: "client_id"))
        handlePushNotification()
    }

    @IBAction func openMiniapp(_ sender: Any) {
        let miniApp = AppBoxo.shared.getMiniApp(appId: "app_id", authPayload: "payload", data: "data")
        miniApp.setConfig(config: MiniAppConfig())
        //miniApp.delegate = self
        miniApp.open(viewController: self)
    }
    
    @objc func handlePushNotification() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let push = UserDefaults.standard.value(forKey: "Notification") as? [String : Any], let miniAppId = push["miniapp_id"] as? String {
                UserDefaults.standard.setValue(nil, forKey: "Notification")
                let miniApp = AppBoxo.shared.getMiniApp(appId: miniAppId, authPayload: "", data: "data")
                miniApp.open(viewController: self)
            }
        }
    }
}

