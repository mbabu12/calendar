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


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize table, sidebarButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    arr = [[NSMutableArray alloc] init];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.sidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [arr count]/10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *simpleTableIdentifier = @"HeaderViewCell";
    HeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *simpleTableIdentifier = @"MainViewCell";
        MainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        CellData *data = [arr objectAtIndex:indexPath.row];
        
        [cell setCellData:data];
        return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
