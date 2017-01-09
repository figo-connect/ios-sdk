
# figo iOS SDK

This Framework wraps the figo Connect API endpoints in nicely typed Swift functions and types for your conveniece.

- We don't support Swift versions older than 3.0
- We are working on support for other platforms than iOS


## figo Connect API

The figo Connect API allows you to easily access your bank account including transaction history and submitting payments.

For a general introduction to figo and figo Connect please visit our [main page](http://figo.io).

Albeit figo offers an interface to submit wire transfers, payment processing is not our focus. Our main interest is bringing peoples bank accounts into applications allowing a more seamless and rich user experience.

API reference: [http://docs.figo.io](http://docs.figo.io)


## Registering your application

Applications that would like to access the figo Connect have to register with us beforehand. If you would like to use figo Connect in your application, please [email](business@figo.me) us. We would love to hear from you what you have in mind and will generate a client identifier and client secret for your application without any bureaucracy.

Website: [http://figo.io](http://figo.io)


## Installation

### Submodule

To add figo as a git submodule run the following command:

`git submodule add https://github.com/figome/ios-sdk.git`

Integrate the framework into your project:

* Open the new folder and drag the Figo.xcodeproj into the Project Navigator of your application's Xcode project.
* Select the Figo.xcodeproj in the Project Navigator and verify the deployment target matches that of your application target.
* Add the Figo.framework to your target(s) in the "Embedded Binaries" sections

### Carthage

We are working on bringing back Carthage support

## Usage

After creating an instance of `FigoClient` you can call functions on it representing the API endpoints. These functions will always return a `Result<T>`, where `T` will a corresponding type like `Account`, `[Account]` or `[Transaction]`.

	import Figo
	let figo = FigoClient()
	
Take a look at the test cases to see more examples of interaction with the API.

### Create user

To be able to login and use the figo API a user is required.

    let params = CreateUserParameters(name: username, email: username, password: password, sendNewsletter: false, language: "de", affiliateUser: nil, affiliateClientID: nil)
    figo.createNewFigoUser(params, clientID: clientID, clientSecret: clientSecret) { result in
    	...
    }

### Login	
    figo.loginWithUsername(username, password: password, clientID: clientID, clientSecret: clientSecret) { result in
        self.refreshToken = result.value
    }

### Retrieve all accounts
    figo.retrieveAccounts() { result in
        if let accounts = result.value {
			for account in accounts {
				...
			}
        }
    }
    
### Check for errors

    figo.retrieveAccounts() { result in
        switch result {
        case .Success(let accounts):
            print("Recieved \(accounts.count) accounts")
            break
        case .Failure(let error):
            print(error.description)
            break
        }
    }
    
### Enable logging

Since the `FigoClient` by default uses the default instance of `XCGLogger`, you can control logging from wherever you like. You can also provide your own `XCGLogger` instance in the initializer.

	XCGLogger.default.setup(level: .verbose, showFunctionName: false, showThreadName: false, showLevel: false, showFileNames: false, showLineNumbers: false, showDate: false, writeToFile: nil, fileLevel: .none)

## Endpoints


### User

The central element of this API is the figo user, who owns bank accounts and grants selective access to them to other applications. This account can either be a free or a premium account. While both support the same set of features, the free account can only be used with the application through it got created, while a premium account can be used in all applications integrating figo.

	createNewFigoUser(user: CreateUserParameters, clientID: String, clientSecret: String, _ completionHandler: (Result<String>) -> Void)
	retrieveCurrentUser(completionHandler: (Result<User>) -> Void)
	deleteCurrentUser(completionHandler: VoidCompletionHandler)


### Authorization

The figo API uses OAuth 2 for authentication purposes and you need a user to login.

	loginWithUsername(username: String, password: String, clientID: String, clientSecret: String, _ completionHandler: (Result<String>) -> Void)
	loginWithRefreshToken(refreshToken: String, clientID: String, clientSecret: String, _ completionHandler: VoidCompletionHandler)
	revokeAccessToken(completionHandler: VoidCompletionHandler)
	revokeRefreshToken(refreshToken: String, _ completionHandler: VoidCompletionHandler)
	
	
### Accounts

Bank accounts are the central domain object of this API and the main anchor point for many of the other resources. This API does not only consider classical bank accounts as account, but also alternative banking services, e.g. credit cards or Paypal. The API does not distinguish between these two in most points.

	retrieveAccounts(completionHandler: (Result<[Account]>) -> Void)
	retrieveAccount(accountID: String, _ completionHandler: (Result<Account>) -> Void)
	removeStoredPinFromBankContact(bankID: String, _ completionHandler: VoidCompletionHandler)
	setupNewBankAccount(parameters: CreateAccountParameters, progressHandler: ProgressUpdate? = nil, _ completionHandler: VoidCompletionHandler)
    	
### Transactions

Each bank account has a list of transactions associated with it. The length of this list depends on the bank and time this account has been setup. In general the information provided for each transaction should be roughly similar to the contents of the printed or online transaction statement available from the respective bank. Please note that not all banks provide the same level of detail.
	
	retrieveTransactions(parameters: RetrieveTransactionsParameters = RetrieveTransactionsParameters(), _ completionHandler: (Result<TransactionListEnvelope>) -> Void)
	retrieveTransactionsForAccount(accountID: String, parameters: RetrieveTransactionsParameters = RetrieveTransactionsParameters(), _ completionHandler: (Result<TransactionListEnvelope>) -> Void)
	retrieveTransaction(transactionID: String, _ completionHandler: (Result<Transaction>) -> Void)
		
    	
### Synchronization

As banks commonly do not provide a push mechanism for distributing transaction updates, they need to be polled, which is called synchronization in this API. When triggering a synchronization please make sure that either the PIN for the bank contact is stored inside figo or that the user has the possibility to enter it.

Usually the bank accounts are synchronized on a daily basis. However, the synchronization can be triggered manually.


	synchronize(parameters parameters: CreateSyncTaskParameters = CreateSyncTaskParameters(), progressHandler: ProgressUpdate? = nil, pinHandler: PinResponder, completionHandler: VoidCompletionHandler)
    	
### Supported banks and services

To set up a new bank account in figo, you need to provide the right kind of credentials for each bank. These settings can be retrieved from the API aswell as a list of all supported banks and bank-like services.

	retrieveSupportedBanks(countryCode: String = "de", _ completionHandler: (Result<[SupportedBank]>) -> Void)
	retrieveSupportedServices(countryCode: String = "de", _ completionHandler: (Result<[SupportedService]>) -> Void)
	retrieveLoginSettings(countryCode: String = "de", bankCode: String, _ completionHandler: (Result<LoginSettings>) -> Void)
		
### Payments

In addition to retrieving information on a bank account, this API also provides the ability to submit wires in the name of the account owner.

Submitting a new payment generally is a two-phased process: 1. compile all information on the payment by creating and modifying a payment object 2. submitting that payment object to the bank.

While the first part is normal live interaction with this API, the second one uses the task processing system to allow for more time as bank servers are sometimes slow to respond. In addition you will need a TAN (Transaktionsnummer) from your bank to authenticate the submission.

	retrievePaymentProposals(completionHandler: Result<[PaymentProposal]> -> Void)
	retrievePayments(completionHandler: Result<[Payment]> -> Void)
	retrievePaymentsForAccount(accountID: String, _ completionHandler: Result<[Payment]> -> Void)
	retrievePayment(paymentID: String, accountID: String, _ completionHandler: Result<Payment> -> Void)
	createPayment(parameters: CreatePaymentParameters, _ completionHandler: Result<Payment> -> Void)
	modifyPayment(payment: Payment, _ completionHandler: Result<Payment> -> Void)
	submitPayment(payment: Payment, tanSchemeID: String, pinHandler: PinResponder, challengeHandler: ChallengeResponder, _ completionHandler: VoidCompletionHandler)
		
### Securities

Each depot account has a list of securities associated with it. In general the information provided for each security should be roughly similar to the contents of the printed or online depot listings available from the respective bank. Please note that not all banks provide the same level of detail.

	retrieveSecurities(parameters: RetrieveSecuritiesParameters = RetrieveSecuritiesParameters(), _ completionHandler: (Result<SecurityListEnvelope>) -> Void)
	retrieveSecuritiesForAccount(accountID: String, parameters: RetrieveSecuritiesParameters = RetrieveSecuritiesParameters(), _ completionHandler: (Result<SecurityListEnvelope>) -> Void)
	retrieveSecurity(securityID: String, accountID: String, _ completionHandler: (Result<Security>) -> Void)
		
### Standing orders

Bank accounts can have standing orders associated with it if supported by the respective bank. In general the information provided for each standing order should be roughly similar to the content of the printed or online standing order statement available from the respective bank. Please note that not all banks provide the same level of detail.

	retrieveStandingOrders(completionHandler: (Result<[StandingOrder]>) -> Void)
	retrieveStandingOrdersForAccount(accountID: String, _ completionHandler: (Result<[StandingOrder]>) -> Void)
	retrieveStandingOrder(standingOrderID: String, _ completionHandler: (Result<StandingOrder>) -> Void)
		

		

    
        

## Credits

The Figo Framework uses the following 3rd-party utilities:

- [JohnSundell/Unbox](https://github.com/JohnSundell/Unbox) for unboxing of JSON responses


