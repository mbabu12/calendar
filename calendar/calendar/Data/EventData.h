//
//  EventData.h
//  calendar
//
//  Created by NextepMac on 2/26/15.
//  Copyright (c) 2015 NextepMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventData : NSObject

@property (strong, nonatomic) NSString * eventId;
@property (strong, nonatomic) NSString * catId;
@property (strong, nonatomic) NSString * image;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * eventDescription;
@property (strong, nonatomic) NSString * priority;

@end
