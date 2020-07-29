# Installation

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
  
**Add Privacy - Microphone Usage Description in info.plist**

   You will need to reasoning about the microphone use. For that you'll need to add the Privacy - Microphone Usage Description 
   (NSMicrophoneUsageDescription) field in your Info.plist




**Import the AppBoxo module in your UIApplicationDelegate:**

**Swift**
        
    import AppBoxoSDK
        
**Objective-C**
        
    #import "AppBoxoSDK/AppBoxoSDK-Swift.h"






**Initialize AppBoxo in your app**
    
   Configure a AppBoxo shared instance, typically in your app's application:didFinishLaunchingWithOptions: method::
   
**Swift**
    
    AppBoxo.shared.setConfig(config: Config(clientId: "client_id"))
    
**Objective-C**
  
    [[AppBoxo shared] setConfig:[[Config alloc] initWithClientId: @"client_id"]];
  
  
  
  
  
    
**To open Miniapps, write this code in your ViewController**

**Swift**
    
    import AppBoxoSDK
    
    let miniApp = AppBoxo.shared.getMiniApp(appId: "app_id", authPayload: "auth_payload", data: "data")
    miniApp.open(viewController: self)


**Objective-C**

    #import "AppBoxoSDK/AppBoxoSDK-Swift.h"
    
    MiniApp *miniApp = [[AppBoxo shared] getMiniAppWithAppId:@"app_id" authPayload:@"auth_payload" data:@"data"];
    [miniApp openWithViewController:self];
    
    
    
    
    

**Handle custom events from miniApp.**

**Swift**

    miniApp.delegate = self
    
and implement MiniAppDelegate
    
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
    
**Objective-C**

    [miniApp setDelegate:self];
    
and implement MiniAppDelegate
     
     @interface ViewController () <MiniAppDelegate>
     //...
     @end
     
    @implementation ViewController
    //...

     - (void)didReceiveCustomEventWithMiniApp:(MiniApp *)miniApp params:(NSDictionary<NSString *,id> *)params {
         NSDictionary *dict = @{
             @"message" : @"message",
             @"id" : @1,
             @"checked" : @YES
         };
         [miniApp sendEventWithParams:dict];
     }

     @end

    
    
    
**Handle miniapp lifecycle hooks.**

**Swift**

    miniApp.delegate = self
        
and implement MiniAppDelegate
        
    extension ViewController: MiniAppDelegate {
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
    
**Objective-C**

    [miniApp setDelegate:self];
    
and implement MiniAppDelegate
     
     @interface ViewController () <MiniAppDelegate>
     //...
     @end
     
    @implementation ViewController
    //...

     - (void)onLaunchMiniApp:(MiniApp *)miniApp {
         NSLog(@"onLaunchMiniApp: %@",miniApp.appId);
     }

     - (void)onResumeMiniApp:(MiniApp *)miniApp {
         NSLog(@"onResumeMiniApp: %@",miniApp.appId);
     }

     - (void)onPauseMiniApp:(MiniApp *)miniApp {
         NSLog(@"onPauseMiniApp: %@",miniApp.appId);
     }

     - (void)onCloseMiniApp:(MiniApp *)miniApp {
         NSLog(@"onCloseMiniApp: %@",miniApp.appId);
     }

     - (void)onErrorMiniApp:(MiniApp *)miniApp message:(NSString *)message {
         NSLog(@"onErrorMiniApp: %@ message: %@",miniApp.appId,message);
     }

     @end




To logout from all the miniapps within your mobile application use this method
    
**Swift**

    AppBoxo.shared.logout()

**Objective-C**

    [[AppBoxo shared] logout];
    
    

Here is an example project: https://github.com/Appboxo/ios-sample-superapp




## License

AppBoxo is available under the MIT license. See the LICENSE file for more info.
