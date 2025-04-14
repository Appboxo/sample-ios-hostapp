//
//  AppDelegate.swift
//  SampleHostApp
//
//  Created by Azamat Kushmanov on 10/4/25.
//

import UIKit
import AppBoxoSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = Config(clientId: "CLIENT_ID")
        Appboxo.shared.setConfig(config: config)
        
        return true
    }

}

