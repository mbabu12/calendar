//
//  HeaderViewCell.h
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HeaderViewCell : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *title;

-(void)setCellData:(NSString *)titles;

@end
