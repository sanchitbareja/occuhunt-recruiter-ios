//
//  FairListViewController.h
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/14/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIO.h"

@interface FairListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationBarDelegate, ServerIODelegate> {
    ServerIO *thisServer;
    
}

@property (nonatomic, strong) NSArray *listOfAttendees;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
