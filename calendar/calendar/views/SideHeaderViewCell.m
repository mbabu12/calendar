//
//  SideHeaderViewCell.m
//  calendar
//
//  Created by NextepMac on 12/22/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "SideHeaderViewCell.h"

@implementation SideHeaderViewCell
@synthesize title, image;


- (void)setFormats{
    self.backgroundColor = [UIColor colorWithRed:5.0/255.0 green:5.0/255.0 blue:5.0/255.0 alpha:1];
    [self.title setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];

}

-(void)setCellData:(SideCellData *)Data{
    [self.title setText:Data.text];
    [self.image setImage:[UIImage imageNamed:Data.image]];
}



@end
