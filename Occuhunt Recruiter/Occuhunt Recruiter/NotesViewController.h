//
//  NotesViewController.h
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/16/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIO.h"

@interface NotesViewController : UIViewController <UITextViewDelegate, ServerIODelegate> {
    UITextView *daltvc;
    ServerIO *thisServer;
}

@property (nonatomic, strong) NSString *applicationID;
@property (nonatomic, strong) NSString *userNotes;

@end
