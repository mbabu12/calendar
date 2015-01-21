//
//  HeaderViewCell.m
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "HeaderViewCell.h"

@implementation HeaderViewCell

@synthesize title;

-(void)setCellData:(NSString *)titles{
    [self.title setText:titles];
}

@end
