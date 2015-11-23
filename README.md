

# Figo iOS SDK

The Figo Framework supports iOS, OSX, watchOS and tvOS. Take a look at the test cases if you are not sure how to use the framework's interface.

Website: [http://figo.io](http://figo.io)

API Docs: [http://docs.figo.io](http://docs.figo.io)


### How to add the Figo Framework to your project
The Figo Framework depends on Alamofire, so you need to make sure that you add that to your project too.


#### Carthage


* Install Carthage

	If you don't have Carthage already installed, download and run the .pkg installer for the latest release from [Github](https://github.com/Carthage/Carthage/releases) or use the Homebrew package manager.

* Add a new `Cartfile` to your project folder or update your existing `Cartfile` with

    `github "figome/ios-sdk"`

* Checkout Dependencies

	Run `carthage update` in your project folder to download and build the newest compatible versions of the Figo Framework and it's dependecies.

    You can specify `carthage update --platform iOS` if you only need the iOS build.

* Add Frameworks

    The built artifacts can be found in your project folder under `Carthage\Build`. From there choose the corresponding folder for your target platform(s) and add the frameworks by dragging them into the Linked Frameworks and Libraries section in Xcode.

    If you have problems with App Store submission because your app contains binary images for the simulator, add a new Run Script build phase with the command
    
    `/usr/local/bin/carthage copy-frameworks`
    
    and an entry for each framework:
    
    `$(SRCROOT)/Carthage/Build/iOS/Alamofire.framework`
    `$(SRCROOT)/Carthage/Build/iOS/Figo.framework`


#### CocoaPods


#### Manually

* Add Figo as a git submodule by running the following command:
`$ git submodule add https://github.com/figome/ios-sdk.git`
* Open the new folder and drag the Figo.xcodeproj into the Project Navigator of your application's Xcode project.
* Select the Figo.xcodeproj in the Project Navigator and verify the deployment target matches that of your application target.
* Add the Figo.framework to your target(s) in the "Embedded Binaries" sections



