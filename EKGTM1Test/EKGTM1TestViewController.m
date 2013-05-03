//
//  EKGTM1TestViewController.m
//  EKGTM1Test
//
//  Created by Sandy Wen on 5/2/13.
//  Copyright (c) 2013 Sandy Wen. All rights reserved.
//

#import "EKGTM1TestViewController.h"
#import "GTMOAuthSignIn.h"
#import "GTMOAuthViewControllerTouch.h"
#import "EKRavelryOauthInfo.h"              // This contains the Ravelry keys

@interface EKGTM1TestViewController ()

- (GTMOAuthAuthentication *) authForServer; // prevents compiler error

@end


@implementation EKGTM1TestViewController

@synthesize EKAuth = _EKAuth;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Get the saved authentication, if any, from the keychain.
    GTMOAuthAuthentication *auth = [self authForServer];
    if (auth) {
        
        // For Debugging purposes only: I reset this by changing the KeychainName, rebuild, then
        // change it back. (clunky, maybe add compiler directive instead)
        BOOL didAuth = [GTMOAuthViewControllerTouch authorizeFromKeychainForName:EKRavelryKeychainItemName
                                                                  authentication:auth];
        
        // if the auth object contains an access token, didAuth is now true
        if (didAuth) {
            NSLog(@"Already authorized!");
            
            // retain the authentication object, which holds the auth tokens
            // we can determine later if the auth object contains an access token
            // by calling its -canAuthorize method
            if (auth.canAuthorize) {
                NSLog(@"Access token:%@",auth.accessToken);
                [self setEKAuth:auth];
            } else {
                // reauthorize
                [self signInToServer];
            }
            
        } else { // No authorization in keychain, sign in
            [self signInToServer];
        }
    }
}

- (void)awakeFromNib
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/** Create authorization object.
 *
 */
- (GTMOAuthAuthentication *)authForServer {
    
    GTMOAuthAuthentication *auth;
    auth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                        consumerKey:EKClientAccessKey
                                                         privateKey:EKClientSecretKey];
    
    // setting the service name lets us inspect the auth object later to know
    // what service it is for
    auth.serviceProvider = EKRavelryServiceName;
    
    return auth;
}

- (void)signInToServer
{
    GTMOAuthAuthentication *auth = [self authForServer];
    
    // set the callback URL to which the site should redirect, and for which
    // the OAuth controller should look to determine when sign-in has
    // finished or been canceled
    //
    [auth setCallback:EKRavelryRedirectURIString];  // not actually used
    NSURL* requestURL = [NSURL URLWithString:EKRavelryRequestTokenURLString];
    NSURL* authURL = [NSURL URLWithString:EKRavelryAuthorizationURLString];
    NSURL* accessURL = [NSURL URLWithString:EKRavelryAccessTokenURLString];
    
    // Display the authentication view
    GTMOAuthViewControllerTouch *viewController;
    viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:EKRavelryScope_Full
                                                                language:nil
                                                         requestTokenURL:requestURL
                                                       authorizeTokenURL:authURL
                                                          accessTokenURL:accessURL
                                                          authentication:auth
                                                         appServiceName:EKRavelryKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [[self navigationController] pushViewController:viewController
                                           animated:YES];
    NSLog (@"Pushed GTMOAuthViewControllerTouch.");
}

#pragma mark selector for GTMOAuthViewController

/** Selector used for GTMOAuthViewControllerTouch initWithScope:...finishedSelector:
 *
 */
- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error
{
    
    if (error != nil) { // Authentication failed
        NSLog(@"Authentication failed!");
        // do other things to handle error
        
    } else { // Authentication succeeded
        NSLog(@"Authentication succeeded!");
        NSLog(@"Authentication token: %@",auth.token);
        self.EKAuth = auth;     // save authorization object for future use
    }
}

@end
