//
//  MainViewCell.m
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "MainViewCell.h"

@implementation MainViewCell

@synthesize number, title, day;

-(void)setCellData:(CellData *)Data{
    [self.number setText:Data.number];
    [self.title setText:Data.title];
    [self.day setText:Data.day];
}


@end
