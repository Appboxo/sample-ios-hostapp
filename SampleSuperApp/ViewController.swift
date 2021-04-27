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
        
        Appboxo.shared.setConfig(config: Config(clientId: "352131"))
        handlePushNotification()
    }

    @IBAction func openDemo(_ sender: Any) {
        let miniapp = Appboxo.shared.getMiniapp(appId: "app16973")
        miniapp.setAuthPayload(authPayload: "payload")
        miniapp.delegate = self
        miniapp.open(viewController: self)
    }
    
    @IBAction func openSkyscanner(_ sender: Any) {
        let miniapp = Appboxo.shared.getMiniapp(appId: "app85076")
        miniapp.setAuthPayload(authPayload: "payload")
        //miniapp.delegate = self
        miniapp.open(viewController: self)
    }
    
    @IBAction func openStore(_ sender: Any) {
        let miniapp = Appboxo.shared.getMiniapp(appId: "app36902")
        miniapp.setAuthPayload(authPayload: "payload")
        miniapp.delegate = self
        miniapp.open(viewController: self)
    }
    
    @objc func handlePushNotification() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let push = UserDefaults.standard.value(forKey: "Notification") as? [String : Any], let miniappId = push["miniapp_id"] as? String {
                UserDefaults.standard.setValue(nil, forKey: "Notification")
                let miniapp = Appboxo.shared.getMiniapp(appId: miniappId)
                miniapp.open(viewController: self)
            }
        }
    }
}

extension ViewController : MiniappDelegate {
    func didReceiveCustomEvent(miniapp: Miniapp, params: [String : Any]) {
        guard miniapp.appId == "app36902" else { return }
        
        
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
    
    func onLaunch(miniapp: Miniapp) {
        print("onLaunchMiniapp: \(miniapp.appId)")
    }
    
    func onResume(miniapp: Miniapp) {
        print("onResumeMiniapp: \(miniapp.appId)")
    }
    
    func onPause(miniapp: Miniapp) {
        print("onPauseMiniapp: \(miniapp.appId)")
    }
    
    func onClose(miniapp: Miniapp) {
        print("onCloseMiniapp: \(miniapp.appId)")
    }
    
    func onError(miniapp: Miniapp, message: String) {
        print("onErrorMiniapp: \(miniapp.appId) message: \(message)")
    }
}

extension ViewController : CheckoutViewControllerDelegate {
    func didSuccessPayment(vc: CheckoutViewController, params: [String : Any]) {
        guard let miniapp = Appboxo.shared.getExistingMiniapp(appId: "app36902") else { return }
        
        var newParams = params
        newParams["payload"] = ["payment":"received"]
        
        miniapp.sendCustomEvent(params: params)
    }
}

