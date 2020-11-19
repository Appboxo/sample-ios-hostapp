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
    
    Appboxo.shared.setConfig(config: Config(clientId: "client_id"))
    
**Objective-C**
  
    [[Appboxo shared] setConfig:[[Config alloc] initWithClientId: @"client_id"]];
  
  
  
  
  
    
**To open miniapps, write this code in your ViewController**

**Swift**
    
    import AppBoxoSDK
    
    let miniapp = Appboxo.shared.getMiniapp(appId: "app_id", authPayload: "auth_payload", data: "data")
    miniapp.open(viewController: self)


**Objective-C**

    #import "AppBoxoSDK/AppBoxoSDK-Swift.h"
    
    Miniapp *miniapp = [[Appboxo shared] getMiniappWithAppId:@"app_id" authPayload:@"auth_payload" data:@"data"];
    [miniapp openWithViewController:self];
    
    
    
    
    

**Handle custom events from miniapp.**

**Swift**

    miniapp.delegate = self
    
and implement MiniappDelegate
    
    extension ViewController: MiniappDelegate {
        func didReceiveCustomEvent(miniapp: Miniapp, params: [String : Any]) {
            let params = [
                "message" : "message",
                "id" : 1,
                "checked" : true
            ]
            miniapp.sendEvent(params: params)
        }
    }
    
**Objective-C**

    [miniapp setDelegate:self];
    
and implement MiniappDelegate
     
     @interface ViewController () <MiniappDelegate>
     //...
     @end
     
    @implementation ViewController
    //...

     - (void)didReceiveCustomEventWithMiniapp:(Miniapp *)miniapp params:(NSDictionary<NSString *,id> *)params {
         NSDictionary *dict = @{
             @"message" : @"message",
             @"id" : @1,
             @"checked" : @YES
         };
         [miniapp sendCustomEventWithParams:dict];
     }

     @end

    
    
    
**Handle miniapp lifecycle hooks.**

**Swift**

    miniapp.delegate = self
        
and implement MiniappDelegate
        
    extension ViewController: MiniappDelegate {
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
    
**Objective-C**

    [miniapp setDelegate:self];
    
and implement MiniappDelegate
     
     @interface ViewController () <MiniappDelegate>
     //...
     @end
     
    @implementation ViewController
    //...

     - (void)onLaunchMiniapp:(Miniapp *)miniapp {
         NSLog(@"onLaunchMiniapp: %@",miniapp.appId);
     }

     - (void)onResumeMiniapp:(Miniapp *)miniapp {
         NSLog(@"onResumeMiniapp: %@",miniapp.appId);
     }

     - (void)onPauseMiniapp:(Miniapp *)miniapp {
         NSLog(@"onPauseMiniapp: %@",miniapp.appId);
     }

     - (void)onCloseMiniapp:(Miniapp *)miniapp {
         NSLog(@"onCloseMiniapp: %@",miniapp.appId);
     }

     - (void)onErrorMiniapp:(Miniapp *)miniapp message:(NSString *)message {
         NSLog(@"onErrorMiniapp: %@ message: %@",miniapp.appId,message);
     }

     @end




To logout from all the miniapps within your mobile application use this method
    
**Swift**

    Appboxo.shared.logout()

**Objective-C**

    [[Appboxo shared] logout];
    
    

Here is an example project: https://github.com/Appboxo/ios-sample-superapp




## License

AppBoxo is available under the MIT license. See the LICENSE file for more info.
