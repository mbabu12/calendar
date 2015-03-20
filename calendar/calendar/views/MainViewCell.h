//
//  MainViewCell.h
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CellData.h"

@interface MainViewCell : UITableViewCell


-(void)setCellData:(CellData *)Data;

@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) NSString * month;
@property (weak, nonatomic) IBOutlet UIView *circle;

@end
