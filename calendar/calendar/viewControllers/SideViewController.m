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


@implementation SideViewController
@synthesize topView, table, profileImage, logoutButton, nameLabel;

- (void)viewDidLoad {
    [self.topView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1]];
    arr1 = [[NSMutableArray alloc] init];
    arr2 = [[NSMutableArray alloc] init];
    headerArr = [[NSMutableArray alloc] init];
    [self setData];
    
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

- (void)setData{
    for(int i = 0; i < 2; i++){
        SideCellData * data = [SideCellData alloc];
        data.text = @"teqsti";
        data.image = @"img.png";
        [arr1 addObject:data];
    }
    for(int i = 0; i < 4; i++){
        SideCellData * data = [SideCellData alloc];
        data.text = @"teqsti";
        data.image = @"img.png";
        [arr2 addObject:data];
    }
    for(int i = 0; i < 2; i++){
        SideCellData * data = [SideCellData alloc];
        data.text = @"teqsti";
        data.image = @"img.png";
        [headerArr addObject:data];
    }
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
    return 38;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [arr1 count];
    else
        return [arr2 count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *simpleTableIdentifier = @"SideHeaderViewCell";
    SideHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    SideCellData *data = [headerArr objectAtIndex:section];
    [cell setCellData:data];
    [cell setFormats];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SideViewCell";
    SideViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    SideCellData *data;
    
    if(indexPath.section == 0)
        data = [arr1 objectAtIndex:indexPath.row];
    else
        data = [arr2 objectAtIndex:indexPath.row];
    
    [cell setFormats];
    [cell setCellData:data];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
