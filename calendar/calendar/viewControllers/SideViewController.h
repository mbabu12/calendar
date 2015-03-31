//
//  SideViewController.h
//  calendar
//
//  Created by NextepMac on 12/22/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"



@interface SideViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray * arrCat;
    NSMutableArray * headerArr;
    NSMutableArray * showCat;
    NSString * notificationOn;
}


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSString * startUrl;

@property (strong, nonatomic) NSDictionary * parsedObject;


@end
