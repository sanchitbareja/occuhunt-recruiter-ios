//
//  NotesViewController.m
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/16/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import "NotesViewController.h"
#import <DALinedTextView/DALinedTextView.h>

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
    DALinedTextView *daltvc = [[DALinedTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    
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
    daltvc.attributedText = [[NSAttributedString alloc] initWithString:@"Sidwyn is a great student. Sidwyn is the best student." attributes:attribute];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
