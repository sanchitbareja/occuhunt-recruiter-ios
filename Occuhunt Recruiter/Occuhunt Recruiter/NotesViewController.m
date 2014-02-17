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
    daltvc = [[DALinedTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    daltvc.delegate = self;
    
    // Create a new RFToolbarButton
    RFToolbarButton *exampleButton = [RFToolbarButton buttonWithTitle:@"Passionate"];
    RFToolbarButton *exampleButton2 = [RFToolbarButton buttonWithTitle:@"Used Product"];
    RFToolbarButton *exampleButton3 = [RFToolbarButton buttonWithTitle:@"Eng. Approval"];
    RFToolbarButton *exampleButton4 = [RFToolbarButton buttonWithTitle:@"Referral"];
    
    [exampleButton addEventHandler:^{
        [daltvc insertText:@"This student is passionate about our product.\n"];
    } forControlEvents:UIControlEventTouchUpInside];
    [exampleButton2 addEventHandler:^{
        [daltvc insertText:@"This student has used our product before.\n"];
    } forControlEvents:UIControlEventTouchUpInside];
    [exampleButton3 addEventHandler:^{
        [daltvc insertText:@"This student has been approved by the engineer.\n"];
    } forControlEvents:UIControlEventTouchUpInside];
    [exampleButton4 addEventHandler:^{
        [daltvc insertText:@"This student has been referred by"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    // Create an RFKeyboardToolbar, adding all of your buttons, and set it as your inputAcessoryView
    daltvc.inputAccessoryView = [RFKeyboardToolbar toolbarViewWithButtons:@[exampleButton, exampleButton2, exampleButton3, exampleButton4]];
    
    
    [self.view addSubview:daltvc];
    
//    daltvc.text = ;
//    daltvc.font = [UIFont fontWithName:@"Proxima Nova" size:20];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 34.0f;
    paragraphStyle.maximumLineHeight = 34.0f;
    paragraphStyle.minimumLineHeight = 34.0f;
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
    
    [daltvc becomeFirstResponder];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
