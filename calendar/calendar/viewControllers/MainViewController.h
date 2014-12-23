//
//  MainViewController.h
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray * arr;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;

@end

