//
//  ShortcutsDetailViewController.h
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/16/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIO.h"
#import "MainViewController.h"

@interface LoginViewController : UITableViewController <UITextFieldDelegate, ServerIODelegate> {
    UITextField *usernameField;
    UITextField *passwordField;
    UIBarButtonItem *helpButton;
    UIBarButtonItem *loginButton;
    ServerIO *thisServer;
}

@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSString *phrase;
@property (nonatomic, strong) NSString *shortcut;

@property (nonatomic, assign) id delegate;

@end
