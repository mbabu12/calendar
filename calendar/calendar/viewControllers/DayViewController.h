//
//  DayViewController.h
//  calendar
//
//  Created by NextepMac on 12/22/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import "iCarousel.h"

@interface DayViewController : BaseViewController<iCarouselDataSource, iCarouselDelegate>{
    int valueDate;
}

@property (weak, nonatomic) IBOutlet UIImageView *topColor;
@property (weak, nonatomic) IBOutlet UIImageView *back;
@property (weak, nonatomic) IBOutlet UIButton *calendar;
@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *backMain;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) NSString * previous;

@property (strong, nonatomic) NSString * curDate;
@property (strong, nonatomic) NSString * curMonth;
@property (strong, nonatomic) NSString * curYear;
@end
