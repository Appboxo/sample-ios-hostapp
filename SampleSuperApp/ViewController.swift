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
        
        AppBoxo.shared.setConfig(config: Config(clientId: "352131"))
        handlePushNotification()
    }

    @IBAction func openDemo(_ sender: Any) {
        let miniApp = AppBoxo.shared.getMiniApp(appId: "app16973", authPayload: "payload", data: "data")
        //miniApp.delegate = self
        miniApp.open(viewController: self)
    }
    
    @IBAction func openSkyscanner(_ sender: Any) {
        let miniApp = AppBoxo.shared.getMiniApp(appId: "app85076", authPayload: "payload", data: "data")
        //miniApp.delegate = self
        miniApp.open(viewController: self)
    }
    
    @IBAction func openStore(_ sender: Any) {
        let miniApp = AppBoxo.shared.getMiniApp(appId: "app36902", authPayload: "payload", data: "data")
        miniApp.delegate = self
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

extension ViewController : MiniAppDelegate {
    func didReceiveCustomEvent(miniApp: MiniApp, params: [String : Any]) {
        guard miniApp.appId == "app36902" else { return }
        
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

        
            let vc = CheckoutViewController()
            vc.delegate = self
            vc.params = params
            topController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }
    
    func onLaunch(miniApp: MiniApp) {
        print("onLaunchMiniApp: \(miniApp.appId)")
    }
    
    func onResume(miniApp: MiniApp) {
        print("onResumeMiniApp: \(miniApp.appId)")
    }
    
    func onPause(miniApp: MiniApp) {
        print("onPauseMiniApp: \(miniApp.appId)")
    }
    
    func onClose(miniApp: MiniApp) {
        print("onCloseMiniApp: \(miniApp.appId)")
    }
    
    func onError(miniApp: MiniApp, message: String) {
        print("onErrorMiniApp: \(miniApp.appId) message: \(message)")
    }
}

extension ViewController : CheckoutViewControllerDelegate {
    func didSuccessPayment(vc: CheckoutViewController, params: [String : Any]) {
        guard let miniApp = AppBoxo.shared.getMiniApp(appId: "app36902") else { return }
        
        var newParams = params
        newParams["payload"] = ["payment":"received"]
        
        miniApp.sendEvent(params: params)
    }
}

