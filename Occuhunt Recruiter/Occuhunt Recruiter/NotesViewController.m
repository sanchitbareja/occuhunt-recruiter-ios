//
//  NotesViewController.m
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/16/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import "NotesViewController.h"
#import <RFKeyboardToolbar/RFKeyboardToolbar.h>
#import <RFKeyboardToolbar/RFToolbarButton.h>

@interface NotesViewController ()

@end

@implementation NotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Notes";
    daltvc = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    daltvc.delegate = self;
    
    NSArray *listOfShortcuts = [[NSUserDefaults standardUserDefaults] objectForKey:@"shortcuts"];
    // Create a new RFToolbarButton
    NSMutableArray *shortcutButtons = [[NSMutableArray alloc] init];
    for (NSDictionary *eachShortcut in listOfShortcuts) {
        RFToolbarButton *eachButton = [RFToolbarButton buttonWithTitle:[eachShortcut objectForKey:@"phrase"]];
        [eachButton addEventHandler:^{
            [daltvc insertText:[eachShortcut objectForKey:@"shortcut"]];
        } forControlEvents:UIControlEventTouchUpInside];
        [shortcutButtons addObject:eachButton];
    }
    // Create an RFKeyboardToolbar, adding all of your buttons, and set it as your inputAcessoryView
    daltvc.inputAccessoryView = [RFKeyboardToolbar toolbarViewWithButtons:shortcutButtons];
    
    [self.view addSubview:daltvc];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 30.0f;
    paragraphStyle.maximumLineHeight = 30.0f;
    paragraphStyle.minimumLineHeight = 30.0f;
    NSDictionary *attribute = @{
                                NSParagraphStyleAttributeName : paragraphStyle,
                                NSFontAttributeName : [UIFont fontWithName:@"Proxima Nova" size:20.0],
                                NSForegroundColorAttributeName : UIColorFromRGB(0x348891)
                                };
    daltvc.attributedText = [[NSAttributedString alloc] initWithString:@" " attributes:attribute];
    
    
    daltvc.text = @"Write something about this student.";
    daltvc.textColor = [UIColor lightGrayColor]; //optional
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWasShown:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillBeHidden:)
     name:UIKeyboardWillHideNotification object:nil];
    
    thisServer = [[ServerIO alloc] init];
    thisServer.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Going to appear!");
    if (self.userNotes.length > 0) {
        daltvc.text = self.userNotes;
    }
    [daltvc becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [daltvc resignFirstResponder];
    if (self.userNotes.length > 0) {
        NSLog(@"Saving!");
        [thisServer updateApplicationWithApplicationID:self.applicationID andNote:self.userNotes];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length > 0) {
        self.userNotes = textView.text;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write something about this student."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write something about this student.";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    daltvc.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    daltvc.scrollIndicatorInsets = daltvc.contentInset;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    daltvc.contentInset = UIEdgeInsetsZero;
    daltvc.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark - Server IO Delegate

- (void)returnData:(AFHTTPRequestOperation *)operation response:(NSDictionary *)response {
    
}

- (void)returnFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    
}
@end
