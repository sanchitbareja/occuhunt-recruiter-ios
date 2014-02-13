//
//  DetailViewController.m
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/12/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@end

@implementation DetailViewController

- (NSInteger)numberOfControllerCardsInNoteView:(KLNoteViewController*) noteView {
    return 2;
}
- (UIViewController *)noteView:(KLNoteViewController*)noteView viewControllerAtIndex:(NSInteger) index {
    // Get the relevant data for the navigation controller
    
    // Initialize a blank uiviewcontroller for display purposes
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    
    KLNoteViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    
    // Return the custom view controller
    return viewController;
}

// alled on any time a state change has occured - even if a state has changed to itself - (i.e. from KLControllerCardStateDefault to KLControllerCardStateDefault)
-(void) noteViewController: (KLNoteViewController*) noteViewController didUpdateControllerCard:(KLControllerCard*)controllerCard toDisplayState:(KLControllerCardState) toState fromDisplayState:(KLControllerCardState) fromState {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
