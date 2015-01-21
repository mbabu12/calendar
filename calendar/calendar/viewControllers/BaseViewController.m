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



@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize table, sidebarButton, topColor, back, calendar, topDate, dayBox, month, gesture, dayTitle, currentData;

- (void)viewDidLoad {
    [super viewDidLoad];
    arr = [[NSMutableArray alloc] init];
    [self setData];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.table registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeaderViewCell"];
    
    [self.sidebarButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self setValues];
    
}


- (IBAction)moveToDay:(id)sender {
    [self performSegueWithIdentifier:@"view_day" sender:nil];
}

- (IBAction)moveToCalendar:(id)sender {
    [self performSegueWithIdentifier:@"view_cal" sender:nil];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (void)setValues{
    UIImage * image = [UIImage imageNamed:@"back.png"];
    [self.back setImage:image];
    [self.topColor setBackgroundColor:[UIColor colorWithRed:118.0/255.0 green:55.0/255.0 blue:116.0/255.0 alpha:0.9]];
    UIImage * imageBox = [UIImage imageNamed:@"day.png"];
    [self.dayBox setImage:imageBox];
    self.dayBox.layer.cornerRadius = 15;
    self.dayBox.layer.masksToBounds = YES;
    [self.topDate setText:@"9"];
    [self.month setText:@"აპრილი"];
    [self.dayTitle setText:@"ქალთა დღე"];
}

- (void)setData{
    for(int i = 0; i < 100; i++){
        CellData * data = [CellData alloc];
        data.number = [NSString stringWithFormat:@"%d", i];
        data.title = @"satauri";
        data.day = @"paraskevi";
        [arr addObject:data];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
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
    [[NSBundle mainBundle] loadNibNamed:@"HeaderCell" owner:self options:nil];
    HeaderViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:simpleTableIdentifier];
    if(section == 1)
        [cell setCellData:@"თებერვალი"];
    else
        [cell setCellData:@"მაისი"];
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
    MainViewCell *cell = (MainViewCell *)[table cellForRowAtIndexPath:indexPath];
    NSString * day = cell.number.text;
    [self.topDate setText:day];
    HeaderViewCell *header = (HeaderViewCell *)[table headerViewForSection:indexPath.section];
    NSString * months = header.title.text;
    [self.month setText:months];
    int row = indexPath.row;
    int section = indexPath.section;
    if(row == 9){
        row = 0;
        section ++;
    }
    else
        row ++;
    self.currentData = [DayData alloc];
    self.currentData.day = day;
    self.currentData.month = months;
    self.currentData.year = @"2015";
    
    [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
