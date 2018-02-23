# Uber Rides iOS SDK

This [Swift library](https://developer.apple.com/library/ios/documentation/General/Reference/SwiftStandardLibraryReference/) allows you to integrate the Uber Rides API into your iOS app.

## Requirements

- iOS 8.0+
- Xcode 9.0+
- Swift 3.2 / 4.0+

## Installing the Uber Rides SDK

To install the Uber Rides SDK, you may use [CocoaPods](http://cocoapods.org), [Carthage](https://github.com/Carthage/Carthage), or add it to your project manually

```ruby
pod 'UberRides', '~> 0.8'
```

If you get compilation errors with CocoaPods, you may be using Swift 3.2 or no Swift at all in your main target. In that scenario, CocoaPods will set the swift version incorrectly. [See issue](https://github.com/CocoaPods/CocoaPods/issues/6791). To fix this, click on your Pods project and select the `UberRides` target. Search for the `Swift Language Version` property, and change it to "Swift 4.0".

### Carthage
```
github "uber/rides-ios-sdk" ~> 0.8
```

## Getting Started

### SDK Configuration

To begin making calls to the Uber API, you need to register an application on the [Uber Developer Site](https://developer.uber.com/dashboard/create) and get credentials for your app.

Then, configure your Xcode with information for the Uber SDK. Locate the **Info.plist** file for your application. Right-click this file and select **Open As > Source Code**

Add the following code snippet, replacing the placeholders within the square brackets (`[]`) with your app’s information from the developer dashboard. (Note: Do not include the square brackets)

```
<key>UberClientID</key>
<string>[ClientID]</string>
<key>UberServerToken</key>
<string>[Server Token]</string>
<key>UberDisplayName</key>
<string>[App Name]</string>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>uber</string>
    <string>uberauth</string>
</array>
```

**Note:** Your `Server Token` is used to make [Price](https://developer.uber.com/docs/rides/api/v1-estimates-price) & [Time](https://developer.uber.com/docs/rides/api/v1-estimates-time) estimates when your user hasn't authenticated with Uber yet. We suggest adding it in your `Info.plist` only if you need to get estimates before your user logs in.

## Ride Request Button

The `RideRequestButton` is a simple way to show price and time estimates for Uber products and can be customized to perform various actions. The button takes in `RideParameters` that can describe product ID, pickup location, and dropoff location. By default, the button shows no information.

To display a time estimate, set the product ID and pickup location. To display a price estimate, you need to additionally set a dropoff location. 

<p align="center">
  <img src="img/button_metadata.png?raw=true" alt="Request Buttons Screenshot"/>
</p>

Import the library into your project, and add a Ride Request Button to your view like you would any other UIView:

```swift
// Swift
import UberRides

let button = RideRequestButton()
view.addSubview(button)
```

```objective-c
// Objective-C
@import UberRides;

UBSDKRideRequestButton *button = [[UBSDKRideRequestButton alloc] init];
[view addSubview:button];
```

This will create a request button with default behavior, with the pickup pin set to the user’s current location. The user will need to select a product and input additional information when they are switched over to the Uber application.

### Adding Parameters with RideParameters

The SDK provides an simple object for defining your ride requests. The `RideParameters` object lets you specify pickup location, dropoff location, product ID, and more. Creating `RideParameters` is easy using the `RideParametersBuilder` object.

```swift
// Swift
import UberRides
import CoreLocation

let builder = RideParametersBuilder()
let pickupLocation = CLLocation(latitude: 37.787654, longitude: -122.402760)
let dropoffLocation = CLLocation(latitude: 37.775200, longitude: -122.417587)
builder.pickupLocation = pickupLocation
builder.dropoffLocation = dropoffLocation
builder.dropoffNickname = "Somewhere"
builder.dropoffAddress = "123 Fake St."
let rideParameters = builder.build()
```

```objective-c
// Objective-C
@import UberRides;
@import CoreLocation;

UBSDKRideParametersBuilder *builder = [[UBSDKRideParametersBuilder alloc] init];
CLLocation *pickupLocation = [[CLLocation alloc] initWithLatitude:37.787654 longitude:-122.402760];
CLLocation *dropoffLocation = [[CLLocation alloc] initWithLatitude:37.775200 longitude:-122.417587];
[builder setPickupLocation:pickupLocation];
[builder setDropoffLocation:dropoffLocation];
[builder setDropoffAddress:@"123 Fake St."];
[builder setDropoffNickname:@"Somewhere"];
UBSDKRideParameters *rideParameters = [builder build];
```

We suggest passing additional parameters to make the Uber experience even more seamless for your users. For example, dropoff location parameters can be used to automatically pass the user’s destination information over to the driver. With all the necessary parameters set, pressing the button will seamlessly prompt a ride request confirmation screen.

**Note:** If you are using a `RideRequestButton` that deeplinks into the Uber app and you want to specify a dropoff location, you must provide a nickname or formatted address for that location. Otherwise, the pin will not display.

You can also use the `RideRequestButtonDelegate` to be informed of success and failure events during a button refresh.

## Login with Uber

To use any of the SDK's other features, you need to have the end user authorize your application to use the Uber API.

### Setup

First, open up the [Uber Developer Dashboard](https://developer.uber.com/dashboard). Go to the Authorizations tab and under App Signatures, put in your iOS application's Bundle ID.

We also need to register a Redirect URL for your application. This ensures that Uber sends users to the correct application after they log in. Make a URL in this format, and save your application: `YourApplicationBundleID://oauth/consumer`.

In your Xcode project, you need to register your URL scheme as well as the callback URL with the Uber SDK. Copy this into your `Info.plist`, replacing the relevant values:

```
<key>UberCallbackURIs</key>
<array>
    <dict>
        <key>UberCallbackURIType</key>
        <string>General</string>
        <key>URIString</key>
        <string>[Your Bundle ID Here]://oauth/consumer</string>
    </dict>
</array>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>[Your Bundle ID Here]</string>
        </array>
    </dict>
</array>
```

You also need to modify your application's **App Delegate** to make calls to the **RidesAppDelegate** to handle URLs. 

```swift
// Swift
// Add the following calls to your AppDelegate
import UberCore
    
@available(iOS 9, *)
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    let handledUberURL = UberAppDelegate.shared.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any)

    return handledUberURL
}
    
func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    let handledUberURL = UberAppDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)

    return handledUberURL
}
```

```objective-c
// Objective-C
// Add the following calls to your AppDelegate
@import UberCore;

// iOS 9+
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    BOOL handledURL = [[UBSDKAppDelegate shared] application:app open:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    return handledURL;
}

// iOS 8
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handledURL = [[UBSDKAppDelegate shared] application:application open:url sourceApplication:sourceApplication annotation:annotation];
    
    return handledURL;
}
```

### Login Button
The `LoginButton` is a simple way to authorize your users. You initialize the button requesting certain scopes, or permissions from Uber. [More about scopes](https://developer.uber.com/docs/riders/guides/scopes). When the user taps the button, the login will be executed.

You can optionally set a `LoginButtonDelegate` to receive notifications for login/logout success.

```swift
// Swift
import UberCore

let scopes: [UberScope] = [.profile, .places, .request]
let loginManager = LoginManager(loginType: .native)
let loginButton = LoginButton(frame: CGRect.zero, scopes: scopes, loginManager: loginManager)
loginButton.presentingViewController = self
loginButton.delegate = self
view.addSubview(loginButton)

// Mark: LoginButtonDelegate
    
func loginButton(_ button: LoginButton, didLogoutWithSuccess success: Bool) {
	// success is true if logout succeeded, false otherwise
}
    
func loginButton(_ button: LoginButton, didCompleteLoginWithToken accessToken: AccessToken?, error: NSError?) {
    if let _ = accessToken {
        // AccessToken Saved
    } else if let error = error {
        // An error occured
    }
}
```

```objective-c
// Objective-C
@import UberCore;

NSArray<UBSDKScope *> *scopes = @[UBSDKScope.profile, UBSDKScope.places, UBSDKScope.request];

UBSDKLoginManager *loginManager = [[UBSDKLoginManager alloc] initWithLoginType:UBSDKLoginTypeNative];

UBSDKLoginButton *loginButton = [[UBSDKLoginButton alloc] initWithFrame:CGRectZero scopes:scopes loginManager:loginManager];
loginButton.presentingViewController = self;
[loginButton sizeToFit];
loginButton.delegate = self;
[self.view addSubview:loginButton];

#pragma mark - UBSDKLoginButtonDelegate

- (void)loginButton:(UBSDKLoginButton *)button didLogoutWithSuccess:(BOOL)success {
	// success is true if logout succeeded, false otherwise
}

- (void)loginButton:(UBSDKLoginButton *)button didCompleteLoginWithToken:(UBSDKAccessToken *)accessToken error:(NSError *)error {
    if (accessToken) {
		// UBSDKAccessToken saved
    } else if (error) {
		// An error occured
    }
}
```

## Ride Request Widget

The Uber Rides SDK provides a simple way to add the Ride Request Widget in only a few lines of code via the `RideRequestButton`. You simply need to provide a `RideRequesting` object and an optional `RideParameters` object.

```swift
// Swift
// Pass in a UIViewController to modally present the Ride Request Widget over
let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
// Optional, defaults to using the user’s current location for pickup
let location = CLLocation(latitude: 37.787654, longitude: -122.402760)
let builder = RideParametersBuilder()
builder.pickupLocation = location
let button = RideRequestButton(rideParameters: builder.build(), requestingBehavior: behavior)
self.view.addSubview(button)
```

```objective-c
// Objective-C
// Pass in a UIViewController to modally present the Ride Request Widget over
id<UBSDKRideRequesting> behavior = [[UBSDKRideRequestViewRequestingBehavior alloc] initWithPresentingViewController: self];
// Optional, defaults to using the user’s current location for pickup
CLLocation *location = [[CLLocation alloc] initWithLatitude: 37.787654 longitude: -122.402760];
UBSDKRideParametersBuilder *builder = [[UBSDKRideParametersBuilder alloc] init];
[builder setPickupLocation:location];
UBSDKRideParameters *parameters = [builder build];
UBSDKRideRequestButton *button = [[UBSDKRideRequestButton alloc] initWithRideParameters: parameters requestingBehavior: behavior];
[self.view addSubview:button];
```

That’s it! When a user taps the button, a **RideRequestViewController** will be modally presented, containing a **RideRequestView** prefilled with the information provided from the **RideParameters** object. If they aren’t signed in, the modal will display a login page and automatically continue to the Ride Request Widget once they sign in. 

Basic error handling is provided by default, but can be overwritten by specifying a **RideRequestViewControllerDelegate**.

```swift
// Swift
extension your_class : RideRequestViewControllerDelegate {
   func rideRequestViewController(_ rideRequestViewController: RideRequestViewController, didReceiveError error: NSError) {
        let errorType = RideRequestViewErrorType(rawValue: error.code) ?? .unknown
        // Handle error here
        switch errorType {
        case .accessTokenMissing:
        // No AccessToken saved
        case .accessTokenExpired:
        // AccessToken expired / invalid
        case .networkError:
        // A network connectivity error
        case .notSupported:
        // The attempted operation is not supported on the current device
        default:
            // Other error
        }
    }
}

// Use your_class as the delegate
let behavior = RideRequestViewRequestingBehavior(presentingViewController: self)
let delegate = your_class()
behavior.modalRideRequestViewController.rideRequestViewController.delegate = delegate
// Create the button same as before
let button = RideRequestButton(rideParameters: parameters, requestingBehavior: behavior)
```

```objective-c
// Objective-C
// Need to implement the UBSDKRideRequestViewControllerDelegate
@interface your_class () <UBSDKRideRequestViewControllerDelegate>

@end

// Implement the delegate methods
- (void)rideRequestViewController:(UBSDKRideRequestViewController *)rideRequestViewController didReceiveError:(NSError *)error {
    // Handle error here
    RideRequestViewErrorType errorType = (RideRequestViewErrorType)error.code;
    
    switch (errorType) {
        case RideRequestViewErrorTypeAccessTokenExpired:
            // No AccessToken saved
            break;
        case RideRequestViewErrorTypeAccessTokenMissing:
            // AccessToken expired / invalid
            break;
        case RideRequestViewErrorTypeNetworkError:
            // A network connectivity error
            break;
        case RideRequestViewErrorTypeUnknown:
            // Other error
            break;
        default:
            break;
    }
}

// Assign the delegate when you initialize your UBSDKModalViewControllerDelegate
UBSDKRideRequestViewRequestingBehavior *requestBehavior = [[UBSDKRideRequestViewRequestingBehavior alloc] initWithPresentingViewController:self];
// Subscribe as the delegete
requestBehavior.modalRideRequestViewController.delegate = self;
// Create the button same as before
UBSDKRideRequestButton *button = [[UBSDKRideRequestButton alloc] initWithRideParameters: parameters requestingBehavior: requestBehavior];
[self.view addSubview:button];
```

## Custom Integration
If you want to provide a more custom experience in your app, there are a few classes to familiarize yourself with. Read the sections below and you’ll be requesting rides in no time!

### Uber Rides API Endpoints
The SDK exposes all the endpoints available in the [Uber Developers documentation](https://developer.uber.com/docs). Some endpoints can be authenticated with a server token, but for most endpoints, you will require a bearer token. A bearer token can be retrieved via implicit grant, authorization code grant, or SSO. To authorize [privileged scopes](https://developer.uber.com/docs/scopes#section-privileged-scopes), you must use authorization code grant or SSO.

Read the full API documentation at [CocoaDocs](http://cocoadocs.org/docsets/UberRides/0.8.0/)

The `RidesClient` is your source to access all the endpoints available in the Uber Rides API. With just your server token, you can get a list of Uber products as well as price and time estimates. 

```swift
// Swift example
let ridesClient = RidesClient()
let pickupLocation = CLLocation(latitude: 37.787654, longitude: -122.402760)
ridesClient.fetchProducts(pickupLocation: pickupLocation, completion:{ products, response in
    if let error = response.error {
        // Handle error
        return
    }
    for product in products {
        // Use product
    }
})
```

```objective-c
// Objective-C example
UBSDKRidesClient *ridesClient = [[UBSDKRidesClient alloc] init];
CLLocation *pickupLocation = [[CLLocation alloc] initWithLatitude: 37.787654 longitude: -122.402760];
[ridesClient fetchProductsWithPickupLocation: pickupLocation completion:^(NSArray<UBSDKProduct *> * _Nullable products, UBSDKResponse *response) {
    if (response.error) {
        // Handle error
        return;
    }
    for (UBSDKProduct *product in products) {
        // Use product
    }
}];
```

### Native / SSO Authorization
To get access to more informative endpoints, you need to have the end user authorize your application to access their Uber data.

The easiest form of authorization is using the `.native` login type. It allows you to request Privileged scopes and, if your user is logged into the Uber app, it doesn't require your user to enter a username and password. It requires the user to have the native Uber application on their device. The `LoginManager` defaults to using the Native login type, so you simply instantiate a `LoginManager` and call `login()` with your requested scopes.

```swift
// Swift
let loginManager = LoginManager()
loginManager.login(requestedScopes:[.request], presentingViewController: self, completion: { accessToken, error in
// Completion block. If accessToken is non-nil, you’re good to go
// Otherwise, error.code corresponds to the RidesAuthenticationErrorType that occured
})
```

```objective-c
// Objective-C
UBSDKLoginManager *loginManager = [[UBSDKLoginManager alloc] init];
[loginManager loginWithRequestedScopes:@[ UBSDKScope.request ] presentingViewController: self completion: ^(UBSDKAccessToken * _Nullable accessToken, NSError * _Nullable error) {
// Completion block. If accessToken is non-nil, you're good to go
// Otherwise, error.code corresponds to the RidesAuthenticationErrorType that occured
}];
```

**Note:** The `presentingViewController` parameter is optional, but if provided, will attempt to intelligently fallback to another login method. Otherwise, it will redirect the user to the App store to download the Uber app.


| Auth Method              | Token Type | Allowed Scopes                           |
| :----------------------- | :--------- | :--------------------------------------- |
| None                     | Server     | None (can access products and estimates) |
| Implicit Grant           | Bearer     | General                                  |
| Authorization Code Grant | Bearer     | Privileged and General                   |
| SSO                      | Bearer     | Privileged and General                   |

### Custom Authorization / TokenManager
If your app allows users to authorize via your own customized logic, you will need to create an `AccessToken` manually and save it in the keychain using the `TokenManager`.

```swift
// Swift
let accessTokenString = "access_token_string"
let token = AccessToken(tokenString: accessTokenString)
if TokenManager.save(accessToken: token) {
    // Success
} else {
    // Unable to save
}
```

```objective-c
// Objective-C
NSString *accessTokenString = @"access_token_string";
UBSDKAccessToken *token = [[UBSDKAccessToken alloc] initWithTokenString: accessTokenString];
if ([UBSDKTokenManager saveWithAccessToken: token]) {
	// Success
} else {
	// Unable to save
}
```

The `TokenManager` can also be used to fetch and delete `AccessToken`s

```swift
// Swift
TokenManger.fetchToken()
TokenManager.deleteToken()
```

```objective-c
// Objective-C
[UBSDKTokenManager fetchToken];
[UBSDKTokenManager deleteToken];
```

## Getting help

Uber developers actively monitor the [Uber Tag](http://stackoverflow.com/questions/tagged/uber-api) on StackOverflow. If you need help installing or using the library, you can ask a question there. Make sure to tag your question with uber-api and ios!

For full documentation about our API, visit our [Developer Site](https://developer.uber.com/).

## Contributing

We :heart: contributions. Found a bug or looking for a new feature? Open an issue and we'll respond as fast as we can. Or, better yet, implement it yourself and open a pull request! We ask that you include tests to show the bug was fixed or the feature works as expected.

**Note:** All contributors also need to fill out the [Uber Contributor License Agreement](http://t.uber.com/cla) before we can merge in any of your changes.

Please open any pull requests against the `develop` branch. 

## License

The Uber Rides iOS SDK is released under the MIT license. See the LICENSE file for more details.
