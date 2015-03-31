//
//  AppSettings.h
//  calendar
//
//  Created by NextepMac on 3/19/15.
//  Copyright (c) 2015 NextepMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

@property NSMutableArray *array;
@property NSString * year;
@property NSMutableArray *arrDay;
@property NSMutableArray *arrMonth;
@property NSMutableArray *arrCat;

+(AppSettings *)sharedInstance;

@end
