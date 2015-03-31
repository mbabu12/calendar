//
//  BaseViewController.h
//  calendar
//
//  Created by NextepMac on 1/6/15.
//  Copyright (c) 2015 NextepMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayData.h"

@interface BaseViewController : UIViewController{
  
    
}

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gesture;
@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, readwrite, retain) DayData * currentData;
@property (weak, nonatomic) IBOutlet UIButton *calendar;

-(void)enableViewContent:(BOOL)enable;

@end

