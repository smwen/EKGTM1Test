iOS Test Application for gtm-oauth
==================================

This application illustrates how to use [`gtm-oauth`](http://code.google.com/p/gtm-oauth/) for logging in and authenticating with a server that supports OAuth 1. The given example logs in to [Ravelry] (http://www.ravelry.com/), however the code is easily adaptable for other sites.

Usage
-----
After cloning the repo, open the project file `EGTM1Test.xcodeproj`. The necessary Frameworks are already linked, and the no-ARC compiler switches are set up for the files in the GTM group.

Before using, edit `EKRavelryOauthInfo.m` to contain your client access key and secret, and your keychain name.

What's Happening
----------------
The calls to `gtm-oauth` occur in `EKGTM1TestViewController.m.` 

In `viewDidLoad`, the keychain is checked to see if the app was previously authorized. If it was not, then `signInToServer` is called.
`signInToServer` then creates a new `GTMOAuthAuthentication` object (by calling `authForServer`), assigned to the local variable `auth`. The `auth` object is then used to create a `GTMOAuthViewControllerTouch`, which opens a Ravelry login page and asks the user to authorize the application's access.

The storyboard contains a `UINavigationController` which is the root controller of `EKGTM1TestViewController`. The `GTMOAuthViewControllerTouch` object created previously is pushed onto the stack during the OAuth interactions.
