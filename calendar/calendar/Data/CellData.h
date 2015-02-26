//
//  CellData.h
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellData : NSObject

@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSString *month;
@property (assign, nonatomic) BOOL isWork;
@property (strong, nonatomic) NSMutableArray * events;

@end
