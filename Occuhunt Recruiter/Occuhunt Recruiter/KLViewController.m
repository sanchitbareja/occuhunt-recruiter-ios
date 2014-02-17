//
//  KLViewController.m
//  KLNoteViewController
//
//  Created by Kieran Lafferty on 2012-12-29.
//  Copyright (c) 2012 Kieran Lafferty. All rights reserved.
//

#import "KLViewController.h"
#import "KLCustomViewController.h"
#import "FairListViewController.h"
#import "PersonViewController.h"
#import "NotesViewController.h"
#import "FairListViewController.h"
#import "SharpLabel.h"
#import "SettingsViewController.h"
#import <VENVersionTracker/VENVersionTracker.h>
#import <VENVersionTracker/VENVersion.h>
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import "LoginViewController.h"

@interface KLViewController ()

@end

@implementation KLViewController

- (void)loadView {
    [super loadView];
    self.occuhuntRecruiterLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:26];
    self.occuhuntRecruiterLabel.textColor = UIColorFromRGB(0x939393);

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 130, screenRect.size.width, screenRect.size.height-130) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.userInteractionEnabled = YES;
    [self.view addSubview:_collectionView];
    
    self.listOfAttendees = [[NSMutableArray alloc] init];
    
    thisServer = [[ServerIO alloc] init];
    thisServer.delegate = self;
    
    eventsButton.enabled = NO;
    [thisServer getFairs];

    self.allFourLists = [[NSMutableArray alloc] init];
    self.appliedList = [[NSMutableArray alloc] init];
    self.interactedWithList = [[NSMutableArray alloc] init];
    self.rejectedList = [[NSMutableArray alloc] init];
    self.interviewingList = [[NSMutableArray alloc] init];
    self.listOfAttendees = [[NSMutableArray alloc] init];
    
    [VENVersionTracker beginTrackingVersionForChannel:@"production"
                                       serviceBaseUrl:@"http://www.occuhunt.com/static/version/appversion-recruiter.json"
                                         timeInterval:1800
                                          withHandler:^(VENVersionTrackerState state, VENVersion *version) {
                                              
                                              dispatch_sync(dispatch_get_main_queue(), ^{
                                                  
                                                  self.appStoreLink = version.installUrl;
                                                  switch (state) {
                                                      case VENVersionTrackerStateDeprecated:
                                                          [version install];
                                                          break;
                                                          
                                                      case VENVersionTrackerStateOutdated:
                                                          // Offer the user the option to update
                                                          [self callAlertView];
                                                          break;
                                                      default:
                                                          break;
                                                  }
                                              });
                                          }];
    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"company_id"]) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.delegate = self;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:lvc];
        nc.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nc animated:YES completion:nil];
//    }
}

- (void)forceCheck {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"company_id"] length] < 1) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.delegate = self;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:lvc];
        nc.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (void)forceReload {
    NSString *companyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"company_id"];
    eventsButton.title = [self.currentlySelectedEvent objectForKey:@"name"];
//    [thisServer getAttendees:[fair objectForKey:@"id"]];
    [thisServer getAttendeesWithStatus:[self.currentlySelectedEvent objectForKey:@"id"] andCompanyID:companyID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)callAlertView {
    [UIAlertView showWithTitle:@"Update Available"
                       message:@"There is a new version of Occuhunt. Update now?"
             cancelButtonTitle:@"Not Now"
             otherButtonTitles:@[@"Update"]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex]) {
                              NSLog(@"Cancelled");
                          } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Update"]) {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appStoreLink]];
                          }
                      }];
}

#pragma mark - IBActions
- (IBAction)chooseEvents:(id)sender
{
    if (self.eventLPC == nil) {
        //Create the ColorPickerViewController.
        self.eventLPC = [[EventListPickerController alloc] initWithStyle:UITableViewStylePlain andEvents:self.listOfEvents];
        //Set this VC as the delegate.
        self.eventLPC.delegate = self;
    }
    
    if (self.eventPickerPopover == nil) {
        //The color picker popover is not showing. Show it.
        self.eventPickerPopover = [[UIPopoverController alloc] initWithContentViewController:self.eventLPC];
        [self.eventPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        //The color picker popover is showing. Hide it.
        [self.eventPickerPopover dismissPopoverAnimated:YES];
        self.eventPickerPopover = nil;
    }
}

- (IBAction)openSettings:(id)sender {
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    svc.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:svc];
    nc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - EventPickerDelegate method
-(void)selectedEvent:(NSDictionary *)selectedEvent
{
    //Dismiss the popover if it's showing.
    if (self.eventPickerPopover) {
        [self.eventPickerPopover dismissPopoverAnimated:YES];
        self.eventPickerPopover = nil;
    }
    [self selectFair:selectedEvent];
}

- (void)selectFair:(NSDictionary *)fair{
    NSString *companyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"company_id"];
    
    self.currentlySelectedEvent = fair;
    eventsButton.title = [self.currentlySelectedEvent objectForKey:@"name"];
    [thisServer getAttendees:[fair objectForKey:@"id"]];
    [thisServer getAttendeesWithStatus:[fair objectForKey:@"id"] andCompanyID:companyID];
}

#pragma mark - Segemented Control Method

- (IBAction)segmentedIndexChanged:(id)sender {
    int index = [(UISegmentedControl *)sender selectedSegmentIndex];
    NSLog(@" MY SEGMENTED INDEX IS %i", index);
    switch (index) {
        case 0:
            self.selectedFromSegmentedIndexList = self.listOfAttendees;
            break;
        case 1:
            self.selectedFromSegmentedIndexList = self.appliedList;
            break;
        case 2:
            self.selectedFromSegmentedIndexList = self.interactedWithList;
            break;
        case 3:
            self.selectedFromSegmentedIndexList = self.rejectedList;
            break;
        case 4:
            self.selectedFromSegmentedIndexList = self.interviewingList;
            break;
        default:
            break;
    }
    [self.collectionView reloadData];
}

#pragma mark - ServerIO Delegate Methods

- (void)returnData:(AFHTTPRequestOperation *)operation response:(NSDictionary *)response {
    if (operation.tag == GETATTENDEES) {
        if ([[response objectForKey:@"response"] objectForKey:@"applications"]) {
            self.listOfAttendees = [[[response objectForKey:@"response"] objectForKey:@"applications"] copy];
        }
        self.selectedFromSegmentedIndexList = self.listOfAttendees;
        [self.collectionView reloadData];
    }
    else if (operation.tag == GETFAIRS) {
        self.listOfEvents = [response objectForKey:@"objects"];
        if ([self.listOfEvents count] > 0) {
            eventsButton.enabled = YES;
            [self selectFair:[self.listOfEvents objectAtIndex:0]];
        }
    }
    else if (operation.tag == GETATTENDEESWITHSTATUS) {
        if ([[response objectForKey:@"response"] objectForKey:@"applications"]) {
            self.allFourLists = [[response objectForKey:@"response"] objectForKey:@"applications"];
            NSLog(@"My segmented index is %i", self.statusSegmentedControl.selectedSegmentIndex);
            [self.appliedList removeAllObjects];
            [self.interactedWithList removeAllObjects];
            [self.rejectedList removeAllObjects];
            [self.interviewingList removeAllObjects];
            for (NSDictionary *eachApplicant in self.allFourLists) {
                switch ([[eachApplicant objectForKey:@"status"] integerValue]) {
                    case 1:
                        [self.appliedList addObject:eachApplicant];
                        break;
                    case 2:
                        [self.interactedWithList addObject:eachApplicant];
                        break;
                    case 3:
                        [self.rejectedList addObject:eachApplicant];
                        break;
                    case 4:
                        [self.interviewingList addObject:eachApplicant];
                        break;
                        
                    default:
                        break;
                }
            }
            [self segmentedIndexChanged:self.statusSegmentedControl];
            [self.collectionView reloadData];
        }
    }
}

- (void)returnFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    
}


#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.selectedFromSegmentedIndexList.count > 0) {
        NSLog(@"Yup returning count %i", self.selectedFromSegmentedIndexList.count);
        return self.selectedFromSegmentedIndexList.count;
    }
    else return 0;
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    UILabel *attendeeName;
    if ([cell.contentView viewWithTag:100]) {
        attendeeName = (UILabel *) [cell.contentView viewWithTag:100];
        attendeeName.text = @"";
    }
    else {
        attendeeName = [[UILabel alloc] initWithFrame:CGRectMake(2, 60, 138, 20)];
        attendeeName.tag = 100;
        attendeeName.textAlignment = NSTextAlignmentCenter;
        attendeeName.backgroundColor = [UIColor clearColor];
        attendeeName.font = [UIFont fontWithName:@"Proxima Nova" size:16];
        attendeeName.textColor = [UIColor blackColor];
        attendeeName.lineBreakMode = NSLineBreakByWordWrapping;
        attendeeName.numberOfLines = 0;
    }
    attendeeName.text = [[[self.selectedFromSegmentedIndexList objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"first_name"];
    cell.backgroundColor = UIColorFromRGB(0xeef7f7);
    cell.layer.borderColor = [UIColorFromRGB(0xadadad) CGColor];
    cell.layer.borderWidth = 0.5f;
    [cell.contentView addSubview:attendeeName];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(140, 140);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected");
    PersonViewController *pvc = [[PersonViewController alloc] init];
    NSDictionary *currentlySelectedUser = [[self.selectedFromSegmentedIndexList objectAtIndex:indexPath.row] objectForKey:@"user"];
    pvc.userID = [currentlySelectedUser objectForKey:@"id"];
    pvc.userApplication = currentlySelectedUser;
    pvc.eventID = [self.currentlySelectedEvent objectForKey:@"id"];
    pvc.title = [NSString stringWithFormat:@"%@ %@", [currentlySelectedUser objectForKey:@"first_name"], [currentlySelectedUser objectForKey:@"last_name"]];
    pvc.delegate = (id) self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:pvc];
    [self presentViewController:nc animated:YES completion:nil];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Recruiter - Selected Student"];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
    
}

@end
