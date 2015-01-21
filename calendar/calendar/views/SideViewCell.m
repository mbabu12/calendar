//
//  SideViewCell.m
//  calendar
//
//  Created by NextepMac on 12/22/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "SideViewCell.h"

@implementation SideViewCell
@synthesize text, image, switchDays;

- (void)setFormats{
    [self.text setTextColor:[UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1]];
     self.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1];
}

-(void)setCellData:(SideCellData *)Data{
    [self.text setText:Data.text];
    [self.image setImage:[UIImage imageNamed:Data.image]];
}

@end
