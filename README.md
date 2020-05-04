## Installation

**Install the following:**
  - Xcode 11.1 or later
  - CocoaPods 1.8.1 or later
  
**Make sure that your project meets the following requirements:**

  - Your project must target iOS 11.1 or later.
  - Swift projects must use Swift 5.0 or later.
  
  
  
**CocoaPods installation**
    
   CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. 
   To integrate AppBoxoSDK into your Xcode project using CocoaPods, specify it in your Podfile:
    
    pod 'AppBoxoSDK'




**Add Camera Usage Description in info.plist**

  You will need to reasoning about the camera use. For that you'll need to add the Privacy - Camera Usage Description 
  (NSCameraUsageDescription) field in your Info.plist

**Add Privacy - Location When In Use Usage Description in info.plist**
  
  You will need to reasoning about the location use. For that you'll need to add the Privacy - Location When In Use Usage Description 
  (NSLocationWhenInUseUsageDescription) field in your Info.plist
  




**Import the AppBoxo module in your UIApplicationDelegate:**
    
    import AppBoxoSDK
    
**Initialize AppBoxo in your app**
    
   Configure a AppBoxo shared instance, typically in your app's application:didFinishLaunchingWithOptions: method::
    
    AppBoxo.shared.setConfig(config: Config(clientId: "client_id"))
  
**Import the AppBoxoSDK module to your ViewController**
    
    import AppBoxoSDK
    
**To open Miniapps, write this code in your ViewController**
    
    guard let miniApp = AppBoxo.shared.createMiniApp(appId: "app_id",
                                                     payload: "payload") else { return }
    miniApp.delegate = self // to receive CustomEvents
    miniApp.open(viewController: self)

If miniApp was already created, Appboxo.createMiniApp(...) returns nil. It will be automatically destroyed after finishing miniApp view controller. Or you can use miniApp.close()


**Handle custom events from miniApp.**

    miniApp.delegate = self
    
And implement MiniAppDelegate

    extension ViewController: MiniAppDelegate {
        func didReceiveCustomEvent(miniApp: MiniApp, params: [String : Any]) {
            let params = [
                "message" : "message",
                "id" : 1,
                "checked" : true
            ]
            miniApp.sendEvent(params: params)
        }
    }


To logout from all the miniapps within your mobile application use this method
    
    AppBoxo.shared.logout()



Here is an example project: https://github.com/Appboxo/ios-sample-superapp




## License

AppBoxo is available under the MIT license. See the LICENSE file for more info.
