//
//  KLViewController.h
//  KLNoteViewController
//
//  Created by Kieran Lafferty on 2012-12-29.
//  Copyright (c) 2012 Kieran Lafferty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLNoteViewController.h"
#import "ServerIO.h"
#import "EventListPickerController.h"
@interface MainViewController : KLNoteViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationBarDelegate, ServerIODelegate, EventListPickerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    ServerIO *thisServer;
    IBOutlet UIBarButtonItem *eventsButton;
    IBOutlet UIBarButtonItem *candidateStatusButton;
    IBOutlet UILabel *eventName;
    
    BOOL isSearching;
    UIRefreshControl *refreshControl;
}

@property (nonatomic, strong) IBOutlet UISegmentedControl *statusSegmentedControl;

@property (nonatomic, strong) IBOutlet UILabel *occuhuntRecruiterLabel;
@property (nonatomic, strong) NSArray* viewControllerData;
@property (nonatomic, strong) NSString *appStoreLink;

@property (nonatomic, strong) NSMutableArray *listOfAttendees;
@property (nonatomic, strong) NSArray *listOfEvents;
@property (nonatomic, strong) NSDictionary *currentlySelectedEvent;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *allFourLists;
@property (nonatomic, strong) NSMutableArray *appliedList;
@property (nonatomic, strong) NSMutableArray *interactedWithList;
@property (nonatomic, strong) NSMutableArray *rejectedList;
@property (nonatomic, strong) NSMutableArray *interviewingList;
@property (nonatomic, strong) NSMutableArray *selectedFromSegmentedIndexList;

@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) EventListPickerController *eventLPC;
@property (nonatomic, strong) UIPopoverController *eventPickerPopover;

@property (nonatomic, strong) EventListPickerController *candidateStatusLPC;
@property (nonatomic, strong) UIPopoverController *candidateStatusPickerPopover;

//@property (nonatomic, strong) EventListPickerController *eventLPC;
//@property (nonatomic, strong) UIPopoverController *eventPickerPopover;

@property (nonatomic, strong) NSMutableArray *contentList;
@property (nonatomic, strong) NSMutableArray *filteredContentList;

// Searching

@property (strong, nonatomic) IBOutlet UITableView *tblContentList;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;

- (IBAction)chooseEvents:(id)sender;
- (IBAction)chooseStatus:(id)sender;

- (void)forceCheck;
- (void)forceReload;

@end
