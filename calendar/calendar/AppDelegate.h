//
//  AppDelegate.h
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    @public
    NSString * imageUrl;
    NSString * name;
    bool isOpened;
}


@property (strong, nonatomic) UIWindow *window;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end

