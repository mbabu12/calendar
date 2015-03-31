//
//  SideViewController.m
//  calendar
//
//  Created by NextepMac on 12/22/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "SideViewController.h"
#import "SideHeaderViewCell.h"
#import "SideViewCell.h"
#import "SideCellData.h"
#import "Reachability.h"


@implementation SideViewController
@synthesize topView, table, profileImage, logoutButton, nameLabel;

- (void)viewDidLoad {
    [self.topView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    showCat = [[NSMutableArray alloc] init];
    if([defaults objectForKey:@"categories"] != nil){
        showCat = [[defaults objectForKey:@"categories"] mutableCopy];
    }
    
    if([defaults objectForKey:@"notification"] != nil)
        notificationOn = [defaults objectForKey:@"notification"];
    else
        [defaults setObject:@"0" forKey:@"notification"];
    
    arrCat = [[NSMutableArray alloc] init];
    headerArr = [[NSMutableArray alloc] init];
    
    SideCellData * data = [SideCellData alloc];
    data.text = @"კატეგორიები";
    data.image = @"calBlue.png";
    [headerArr addObject:data];
    
    self.startUrl = @"http://nextep.ge/content/calendar/category/";
    
    self.parsedObject = [[NSDictionary alloc] init];
    self.parsedObject = [defaults objectForKey:@"allCat"];
    [self parseData];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"SideViewSessionOpen"
                                               object:nil];

    [self changePicture];
}

- (void)viewWillAppear:(BOOL)animated{
  //  [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
 //   [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}



- (void)parseData{
    NSArray * categories = self.parsedObject[@"Data"];
    for(int i = 0; i < [categories count]; i++){
        NSDictionary * temp = [categories objectAtIndex:i];
        SideCellData * data = [SideCellData alloc];
        data.cId = temp[@"Id"];
        data.text = temp[@"Name"];
        data.image = temp[@"ImageId"];
        if([data.text isEqual:@"სახელმწიფო"])
            [arrCat insertObject:data atIndex:0];
        else
            [arrCat addObject:data];
    }
    
    [table reloadData];

}


- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"SideViewSessionOpen"]){
        [self changePicture];
    }
}

- (void)changePicture{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate -> isOpened){
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:appDelegate->imageUrl]];
        [self.profileImage setImage:[UIImage imageWithData:data]];
        self.logoutButton.hidden = NO;
    }
    else{
        [self.profileImage setImage:[UIImage imageNamed:appDelegate->imageUrl]];
        self.logoutButton.hidden = YES;
    }
    self.nameLabel.text = appDelegate -> name;
}

 
- (IBAction)touch:(id)sender {
    if (FBSession.activeSession.state != FBSessionStateOpen
        & FBSession.activeSession.state != FBSessionStateOpenTokenExtended) {
        
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             
             
             
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
         }];
        
        [self changePicture];
    }

}

- (IBAction)buttonTouched:(id)sender
{
    
}



- (IBAction)buttonTouchedClose:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
       
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        [self changePicture];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 1;
    return 38;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    return [arrCat count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return nil;
    static NSString *simpleTableIdentifier = @"SideHeaderViewCell";
    SideHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    SideCellData *data = [headerArr objectAtIndex:0];
    [cell setCellData:data];
    [cell setFormats];
    return cell;
}

- (void)changeSwitch:(id)sender{
    int k = [sender tag];
    NSString *idForCat = [NSString stringWithFormat:@"%d", k];
    if([idForCat isEqual:@"0"]){
        if([notificationOn isEqual:@"0"])
            notificationOn = @"1";
        else
            notificationOn = @"0";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:notificationOn forKey:@"notification"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"changeNotification"
         object:self];
    }
    else{
        if([sender isOn]){
            if(![showCat containsObject:idForCat]){
                [showCat addObject:idForCat];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:showCat forKey:@"categories"];
                [defaults synchronize];
            }
        }
        else{
            if([showCat containsObject:idForCat]){
                [showCat removeObject:idForCat];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:showCat forKey:@"categories"];
                [defaults synchronize];
            }

        }
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"changeCategory"
         object:self];
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SideViewCell";
    SideViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(indexPath.section == 0){
        [cell.text setText:@"შეგაწუხოთ?"];
        [cell.image setImage:[UIImage imageNamed:@"img.png"]];
        [cell.text setTextColor:[UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1]];
        cell.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1];
        BOOL k = NO;
        if([notificationOn isEqual:@"1"])
            k = YES;
        if(!k)
            [cell.switchDays setOn:NO];
        else
            [cell.switchDays isOn];
        cell.switchDays.tag = 0;
        [cell.switchDays addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];

        return cell;
    }
    
    SideCellData *data = [arrCat objectAtIndex:indexPath.row];
    if([data.text isEqualToString:@"სახელმწიფო"]){
        [cell.switchDays isOn];
      //  [cell.switchDays setUserInteractionEnabled:NO];
        cell.switchDays.enabled = NO;
    }
    else{
        BOOL isOn = NO;
        for(int i = 0; i < [showCat count]; i++){
            NSString * temp = [showCat objectAtIndex:i];
            if([[NSString stringWithFormat:@"%d", [data.cId intValue]] isEqualToString:temp]){
                [cell.switchDays isOn];
                isOn = YES;
            }
        }
    
        if(!isOn)
            [cell.switchDays setOn:NO];
        cell.switchDays.tag = [data.cId intValue];
        [cell.switchDays addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png", self.startUrl, data.image]]]];
    [cell.image setImage:image];
    [cell setFormats];
    [cell.text setText:data.text];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
