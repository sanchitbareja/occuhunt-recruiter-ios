//
//  ShortcutsDetailViewController.h
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/16/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortcutsDetailViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *phraseTextField;
    UITextField *shortcutTextField;
    UIBarButtonItem *saveButton;
}

@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSString *phrase;
@property (nonatomic, strong) NSString *shortcut;

@end
