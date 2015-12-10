

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/figome/ios-sdk)


# figo iOS SDK

This Framework wraps the figo Connect API endpoints in nicely typed Swift functions and types for your conveniece. It supports iOS, OSX, watchOS and tvOS targets.


## figo Connect API

The figo Connect API allows you to easily access your bank account including transaction history and submitting payments.

For a general introduction to figo and figo Connect please visit our [main page](http://figo.io).

Albeit figo offers an interface to submit wire transfers, payment processing is not our focus. Our main interest is bringing peoples bank accounts into applications allowing a more seamless and rich user experience.

API Reference: [http://docs.figo.io](http://docs.figo.io)


## Registering your application

Applications that would like to access the figo Connect have to register with us beforehand. If you would like to use figo Connect in your application, please [email](business@figo.me) us. We would love to hear from you what you have in mind and will generate a client identifier and client secret for your application without any bureaucracy.

Website: [http://figo.io](http://figo.io)


## Installation

### Manually

* Add Figo as a git submodule by running the following command:

	`$ git submodule add https://github.com/figome/ios-sdk.git`
* Open the new folder and drag the Figo.xcodeproj into the Project Navigator of your application's Xcode project.
* Select the Figo.xcodeproj in the Project Navigator and verify the deployment target matches that of your application target.
* Add the Figo.framework to your target(s) in the "Embedded Binaries" sections

### Carthage


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
    
    and an entry for the Figo framework:
    
    `$(SRCROOT)/Carthage/Build/iOS/Figo.framework`




## Usage

Take a look at the test cases to see more examples of interaction with the API.

### Retrieve all accounts
        Figo.retrieveAccounts() { accounts, _ in
            if let accounts = accounts {
                for account in accounts {
                    print(account.account_id)
                }
            }
        }
### Retrieve a single account
        Figo.retrieveAccount("A1.1") { account, _ in
            if let account = account {
                print(account.account_id)
            }
        }
        

## Credits

The Figo Framework uses the following 3rd-party utilities:

- [DaveWoodCom/XCGLogger](https://github.com/DaveWoodCom/XCGLogger)
- [JohnSundell/Unbox](https://github.com/JohnSundell/Unbox)

