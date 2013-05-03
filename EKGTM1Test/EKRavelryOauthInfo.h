//
//  EKRavelryOauthInfo.h
//  EKGTMTest
//
//  Created by Sandy Wen on 5/2/13.
//  Copyright (c) 2013 Sandy Wen. All rights reserved.
//


#import <Foundation/Foundation.h>

extern NSString* const EKClientAccessKey;
extern NSString* const EKClientSecretKey;
extern NSString* const EKRavelryAuthorizationURLString;
extern NSString* const EKRavelryAccessTokenURLString;
extern NSString* const EKRavelryRequestTokenURLString;
extern NSString* const EKRavelryRedirectURIString;
extern NSString* const EKRavelryKeychainItemName;
extern NSString* const EKRavelryScope_Full; // Does this need to be set?
extern NSString* const EKRavelryServiceName;

@interface EKRavelryOauthInfo : NSObject

@end
