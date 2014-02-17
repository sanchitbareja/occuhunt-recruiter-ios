//
//  NotesViewController.h
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/16/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesViewController : UIViewController <UITextViewDelegate> {
    UITextView *daltvc;
}

@property (nonatomic, strong) NSString *userNotes;

@end
