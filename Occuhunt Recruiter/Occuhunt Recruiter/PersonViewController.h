//
//  PersonViewController.h
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/14/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIO.h"
#import <ChatHeads/CHDraggingCoordinator.h>

@interface PersonViewController : UIViewController <UIScrollViewDelegate, ServerIODelegate, UINavigationBarDelegate, UIBarPositioningDelegate, CHDraggingCoordinatorDelegate> {
    ServerIO *thisServer;
}

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) IBOutlet UIView *resumeView;
@property (nonatomic, strong) IBOutlet UIScrollView *portfolioScrollView;
@property (nonatomic, strong) IBOutlet UIImageView *portfolioImageView;

@property (nonatomic, strong) NSString *resumeLink;

@property (nonatomic, assign) id delegate;

@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator;

- (void)close;

@end
