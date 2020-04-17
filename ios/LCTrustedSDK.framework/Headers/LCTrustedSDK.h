//  LCTrustedSDK
//  Version 1.0.1

#ifndef LCTrustedSDK_h
#define LCTrustedSDK_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for LCTrsutedSDK.
FOUNDATION_EXPORT double sdkVersionNumber;

//! Project version string for LCTrsutedSDK.
FOUNDATION_EXPORT const unsigned char sdkVersionString[];

@protocol LCIdentityDelegate
- (void) onIdentitySuccess;
- (void) onIdentityFailed: (int) errorCode message: (NSString*) errorMessage;
- (void) onMessageSignSuccess:(NSString*) signedMessage status: (NSString*) status;
- (void) onMessageSignFailed: (int) errorCode message: (NSString*) errorMessage;
@end

@interface LCTrustedSDK : NSObject
@property (weak) id <LCIdentityDelegate> delegate;

- (void) createIdentity: (NSString*) challenge;
- (void) signMessage: (NSString*) message;
- (BOOL) isIdentityExist;
- (BOOL) clearIdentity;
- (NSString*) getVersion;

@end

#endif /* LCTrustedSDK_h */
