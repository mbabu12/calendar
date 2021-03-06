//
//  SideHeaderViewCell.h
//  calendar
//
//  Created by NextepMac on 12/22/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SideCellData.h"

@interface SideHeaderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;

-(void)setCellData:(SideCellData *)Data;
-(void)setFormats;

@end
