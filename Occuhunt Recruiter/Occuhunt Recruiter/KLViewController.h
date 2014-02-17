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

@interface KLViewController : KLNoteViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationBarDelegate, ServerIODelegate, EventListPickerDelegate> {
    ServerIO *thisServer;
    IBOutlet UIBarButtonItem *eventsButton;
    IBOutlet UISegmentedControl *statusSegmentedControl;
    IBOutlet UILabel *eventName;
}

@property (nonatomic, strong) IBOutlet UILabel *occuhuntRecruiterLabel;
@property (nonatomic, strong) NSArray* viewControllerData;

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

- (IBAction)chooseEvents:(id)sender;

@end
