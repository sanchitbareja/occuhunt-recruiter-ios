//
//  KLViewController.m
//  KLNoteViewController
//
//  Created by Kieran Lafferty on 2012-12-29.
//  Copyright (c) 2012 Kieran Lafferty. All rights reserved.
//

#import "MainViewController.h"
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

@interface MainViewController ()

@end

@implementation MainViewController

- (void)loadView {
    [super loadView];
    self.occuhuntRecruiterLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:26];
    self.occuhuntRecruiterLabel.textColor = UIColorFromRGB(0x939393);

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setSectionInset:UIEdgeInsetsMake(20, 10, 20, 10)];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, screenRect.size.width, screenRect.size.height-64) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.userInteractionEnabled = YES;
    [self.view addSubview:_collectionView];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(forceReload)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
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
    
    LoginViewController *lvc = [[LoginViewController alloc] init];
    lvc.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:lvc];
    nc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nc animated:YES completion:nil];
    
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"740-gear"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings:)];
    
//    self.navigationItem.rightBarButtonItems = @[searchBarButton, settingsBarButton];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 400, 44.0)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"Search Candidates";
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400, 44.0)];
    searchBarView.autoresizingMask = 0;
    _searchBar.delegate = self;
    [searchBarView addSubview:_searchBar];
    self.navigationItem.titleView = searchBarView;
    
    self.contentList = [[NSMutableArray alloc] init];
    self.filteredContentList = [[NSMutableArray alloc] init];
    
    _tblContentList = [[UITableView alloc] initWithFrame:CGRectMake(screenRect.size.width/2-140, 64, 280, 400) style:UITableViewStylePlain];
    
    _tblContentList.delegate = self;
    _tblContentList.dataSource = self;
    [self.view addSubview:_tblContentList];
    self.tblContentList.hidden = YES;
    
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
        self.eventLPC = [[EventListPickerController alloc] initWithStyle:UITableViewStylePlain andEvents:self.listOfEvents andTag:0];
        self.eventLPC.tag = 0;
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

- (IBAction)chooseStatus:(id)sender
{
    if (self.candidateStatusLPC == nil) {
        //Create the ColorPickerViewController.
        NSArray *statusArray = @[@"Attending", @"Applied", @"Interacted With", @"Rejected", @"Interviewing"];
        self.candidateStatusLPC = [[EventListPickerController alloc] initWithStyle:UITableViewStylePlain andEvents:statusArray andTag:1];
        //Set this VC as the delegate.
        self.candidateStatusLPC.delegate = self;
    }
    
    if (self.candidateStatusPickerPopover == nil) {
        //The color picker popover is not showing. Show it.
        self.candidateStatusPickerPopover = [[UIPopoverController alloc] initWithContentViewController:self.candidateStatusLPC];
        [self.candidateStatusPickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        //The color picker popover is showing. Hide it.
        [self.candidateStatusPickerPopover dismissPopoverAnimated:YES];
        self.candidateStatusPickerPopover = nil;
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

- (void)selectedEvent:(id)selectedEvent andLPC:(EventListPickerController *)lpc
{
    //Dismiss the popover if it's showing.
    if (lpc.tag == 0) {
        if (self.eventPickerPopover) {
            [self.eventPickerPopover dismissPopoverAnimated:YES];
            self.eventPickerPopover = nil;
        }
        NSDictionary *anotherEvent = (NSDictionary *)selectedEvent;
        [self selectFair:anotherEvent];
    }
    else if (lpc.tag == 1) {
        if (self.candidateStatusPickerPopover) {
            [self.candidateStatusPickerPopover dismissPopoverAnimated:YES];
            self.candidateStatusPickerPopover = nil;
        }
        switch ([selectedEvent intValue]) {
            case 0:
                self.selectedFromSegmentedIndexList = self.listOfAttendees;
                [candidateStatusButton setTitle:@"Attending"];
                break;
            case 1:
                self.selectedFromSegmentedIndexList = self.appliedList;
                [candidateStatusButton setTitle:@"Applied"];
                break;
            case 2:
                self.selectedFromSegmentedIndexList = self.interactedWithList;
                [candidateStatusButton setTitle:@"Interacted With"];
                break;
            case 3:
                self.selectedFromSegmentedIndexList = self.rejectedList;
                [candidateStatusButton setTitle:@"Rejected"];
                break;
            case 4:
                self.selectedFromSegmentedIndexList = self.interviewingList;
                [candidateStatusButton setTitle:@"Interviewing"];
                break;
            default:
                break;
        }
        [self.collectionView reloadData];
    }
}

- (void)selectFair:(NSDictionary *)fair{
    NSString *companyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"company_id"];
    
    self.currentlySelectedEvent = fair;
    // Truncate button
    NSString *currentTitle = [self.currentlySelectedEvent objectForKey:@"name"];
    
    // define the range you're interested in
    BOOL toShorten = NO;
    if (currentTitle.length > 17) {
        toShorten = YES;
    }
    NSRange stringRange = {0, MIN([currentTitle length], 17)};
    // adjust the range to include dependent chars
    stringRange = [currentTitle rangeOfComposedCharacterSequencesForRange:stringRange];
    
    // Now you can create the short string
    NSMutableString *shortString = [[currentTitle substringWithRange:stringRange] mutableCopy];
    if (toShorten) {
        [shortString appendString:@"..."];
    }
    
    eventsButton.title = shortString;
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
            [self.contentList removeAllObjects];
            self.contentList = [self.allFourLists mutableCopy];
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
            if (refreshControl.isRefreshing) {
                [refreshControl endRefreshing];
            }
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
        attendeeName = [[UILabel alloc] initWithFrame:CGRectMake(2, 30, 138, 80)];
        attendeeName.tag = 100;
        attendeeName.textAlignment = NSTextAlignmentCenter;
        attendeeName.backgroundColor = [UIColor clearColor];
        attendeeName.font = [UIFont fontWithName:@"Proxima Nova" size:16];
        attendeeName.textColor = [UIColor blackColor];
        attendeeName.lineBreakMode = NSLineBreakByWordWrapping;
        attendeeName.numberOfLines = 0;
    }
    
    
    NSString *firstName = [[[self.selectedFromSegmentedIndexList objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"first_name"];
    int firstNameLength = firstName.length;
    NSString *lastName = [[[self.selectedFromSegmentedIndexList objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"last_name"];
    
    NSString *bothFirstAndLastName = [NSString stringWithFormat:@"%@\n\n %@", firstName, lastName];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:bothFirstAndLastName];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Proxima Nova" size:30.0] range:NSMakeRange(0, firstNameLength)];
    attendeeName.attributedText = str;
    
//    attendeeName.text = [NSString stringWithFormat:@"%@ %@",, [[[self.selectedFromSegmentedIndexList objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"last_name"]];
    cell.backgroundColor = UIColorFromRGB(0xeef7f7);
//    cell.layer.borderColor = [UIColorFromRGB(0xadadad) CGColor];
//    cell.layer.borderWidth = 0.5f;
    [cell.contentView addSubview:attendeeName];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(140, 140);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected");
    NSDictionary *currentlySelectedUser = [[self.selectedFromSegmentedIndexList objectAtIndex:indexPath.row] objectForKey:@"user"];
    [self openPersonViewController:currentlySelectedUser];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
    
}

#pragma mark - Open Person View Controller

- (void)openPersonViewController:(NSDictionary *)selectedUser{
    PersonViewController *pvc = [[PersonViewController alloc] init];
    pvc.userID = [selectedUser objectForKey:@"id"];
    pvc.userApplication = selectedUser;
    pvc.eventID = [self.currentlySelectedEvent objectForKey:@"id"];
    pvc.title = [NSString stringWithFormat:@"%@ %@", [selectedUser objectForKey:@"first_name"], [selectedUser objectForKey:@"last_name"]];
    pvc.delegate = (id) self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:pvc];
    [self presentViewController:nc animated:YES completion:nil];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Recruiter - Selected Student"];

}

#pragma mark - Searching

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (isSearching) {
        return [self.filteredContentList count];
    }
    else {
        return [self.contentList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (isSearching) {
        NSDictionary *eachStudent = [self.filteredContentList objectAtIndex:indexPath.row];
        NSString *firstName = [[eachStudent objectForKey:@"user"] objectForKey:@"first_name"];
        NSString *lastName = [[eachStudent objectForKey:@"user"] objectForKey:@"last_name"];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        cell.textLabel.text = fullName;
    }
    else {
        NSDictionary *eachStudent = [self.selectedFromSegmentedIndexList objectAtIndex:indexPath.row];
        NSString *firstName = [[eachStudent objectForKey:@"user"] objectForKey:@"first_name"];
        NSString *lastName = [[eachStudent objectForKey:@"user"] objectForKey:@"last_name"];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        cell.textLabel.text = fullName;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *currentlySelectedUser = [[self.filteredContentList objectAtIndex:indexPath.row] objectForKey:@"user"];
    [self openPersonViewController:currentlySelectedUser];
}

- (void)searchTableList {
    NSString *searchString = _searchBar.text;
    
    for (NSDictionary *eachStudent in self.selectedFromSegmentedIndexList) {
        NSString *firstName = [[eachStudent objectForKey:@"user"] objectForKey:@"first_name"];
        NSString *lastName = [[eachStudent objectForKey:@"user"] objectForKey:@"last_name"];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        NSComparisonResult result = [fullName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [self.filteredContentList addObject:eachStudent];
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
    [self.filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchTableList];
        _tblContentList.hidden = NO;
    }
    else {
        isSearching = NO;
        _tblContentList.hidden = YES;
    }
    [self.tblContentList reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchTableList];
}

@end
