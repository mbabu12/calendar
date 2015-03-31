//
//  BaseViewController.m
//  calendar
//
//  Created by NextepMac on 1/6/15.
//  Copyright (c) 2015 NextepMac. All rights reserved.
//


#import "BaseViewController.h"
#import "MainViewCell.h"
#import "HeaderViewCell.h"
#import "CellData.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "EventData.h"
#import "DayViewController.h"
#import "CalendarViewController.h"



@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
      //  self.revealViewController.panGestureRecognizer.enabled = YES;
    [self.sidebarButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];

    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)enableViewContent:(BOOL)enable{
    [self.table setUserInteractionEnabled:enable];
    self.gesture.enabled = enable;
    self.calendar.enabled = enable;
}

@end
