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

    var agodaInfo = AgodaInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification), name: .onPushNotificationTapped, object: nil)
        
        Appboxo.shared.setConfig(config: Config(clientId: "client_id"))
        handlePushNotification()
    }

    @IBAction func openDemo(_ sender: Any) {
        let miniapp = Appboxo.shared.getMiniapp(appId: "app16973")
        miniapp.delegate = self
        miniapp.open(viewController: self)
    }
    
    @IBAction func openSkyscanner(_ sender: Any) {
        let miniapp = Appboxo.shared.getMiniapp(appId: "app85076")
        //miniapp.delegate = self
        miniapp.open(viewController: self)
    }
    
    @IBAction func openStore(_ sender: Any) {
        let miniapp = Appboxo.shared.getMiniapp(appId: "app36902")
        miniapp.delegate = self
        miniapp.open(viewController: self)
    }
    
    @IBAction func openAgoda(_ sender: Any) {
        let miniapp = Appboxo.shared.getMiniapp(appId: "app_id")
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
    
    func didChangeUrlEvent(miniapp: Miniapp, url: URL) {
        print("didChangeUrlEvent: \(miniapp.appId) url: \(url)")
        
        if let city = url.queryParameters["city"] { agodaInfo.city = city }
        if let cid = url.queryParameters["cid"] { agodaInfo.cid = cid }
        if let checkIn = url.queryParameters["checkIn"] { agodaInfo.checkIn = checkIn }
        if let checkOut = url.queryParameters["checkOut"] { agodaInfo.checkOut = checkOut }
        if let los = url.queryParameters["los"] { agodaInfo.los = los }
        if let rooms = url.queryParameters["rooms"] { agodaInfo.rooms = rooms }
        if let adults = url.queryParameters["adults"] { agodaInfo.adults = adults }
        if let children = url.queryParameters["children"] { agodaInfo.children = children }
        if let userId = url.queryParameters["userId"] { agodaInfo.userId = userId }
        if let origin = url.queryParameters["origin"] { agodaInfo.origin = origin }
        if let currencyCode = url.queryParameters["currencyCode"] { agodaInfo.currencyCode = currencyCode }
        if let textToSearch = url.queryParameters["textToSearch"] { agodaInfo.textToSearch = textToSearch }
        
        if url.pathComponents.contains("hotel") {
            if let cityName = url.lastPathComponent.replacingOccurrences(of: ".html", with: "").split(separator: "-").first { agodaInfo.cityName = String(cityName) }
            if let countryCode = url.lastPathComponent.replacingOccurrences(of: ".html", with: "").split(separator: "-").last { agodaInfo.countryCode = String(countryCode) }
        }
        
        if url.pathComponents.contains("thankyou") {
            agodaInfo.bookingIdUrl = url.absoluteString
            if let bookingId = url.queryParameters["bookingId"] { agodaInfo.bookingId = bookingId }
        }
        
        print(agodaInfo)
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

extension URL {
    public var queryParameters: [String: String] {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems
        else {
            return [:]
        }
        
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
