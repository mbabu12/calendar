//
//  AppSettings.m
//  calendar
//
//  Created by NextepMac on 3/19/15.
//  Copyright (c) 2015 NextepMac. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

+(AppSettings *)sharedInstance
{
    static AppSettings *sharedData;
    
    @synchronized(self)
    {
        if (!sharedData)
        {
            sharedData = [[AppSettings alloc] init];
        }
        return sharedData;
    }
}

@end
