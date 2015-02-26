//
//  MainViewController.m
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewCell.h"
#import "HeaderViewCell.h"
#import "CellData.h"
#import "SWRevealViewController.h"
#import "DayViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"view_day"])
    {
        DayViewController * controller = [segue destinationViewController];
        controller.currentData = self.currentData;
        controller.allDays = arrDays;
        controller.allMonth = arrMonth;
    }
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}





@end
