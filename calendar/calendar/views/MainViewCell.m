//
//  MainViewCell.m
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "MainViewCell.h"
#import "EventData.h"

@implementation MainViewCell

@synthesize number, title, day, month;



-(void)setCellData:(CellData *)Data{
    
    [self.number setText:Data.number];
    [self.title setText:((EventData *)[Data.events objectAtIndex:0]).name];
    [self.day setText:Data.day];
}


@end
