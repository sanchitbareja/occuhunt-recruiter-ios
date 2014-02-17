//
//  PersonViewController.m
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/14/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import "PersonViewController.h"
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>

@interface PersonViewController ()

@end

@implementation PersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Sidwyn Koh";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.resumeView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.resumeView];
    
    UIBarButtonItem *fairButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Students" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = fairButtonItem;
    
    UIBarButtonItem *statusButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Status: Applied" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = statusButtonItem;
    
    CGRect tempRect = self.view.frame;
    tempRect.origin.y += 64;
    tempRect.size.height -= 64;
    self.portfolioScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.portfolioImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.portfolioImageView setImage:[UIImage imageNamed:@"OccuhuntLogo.png"]];
    [self.portfolioImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.portfolioScrollView addSubview:self.portfolioImageView];
    [self.portfolioScrollView bringSubviewToFront:self.portfolioImageView];

    [self.resumeView addSubview:self.portfolioScrollView];
    [self.resumeView bringSubviewToFront:self.portfolioScrollView];
    

//    self.portfolioScrollView.clipsToBounds = YES;
    self.portfolioScrollView.minimumZoomScale = 0.2;
    self.portfolioScrollView.maximumZoomScale = 2.0;
    self.portfolioScrollView.delegate = self;
    self.portfolioScrollView.contentSize = self.portfolioScrollView.frame.size;
    self.portfolioScrollView.userInteractionEnabled = YES;
    self.portfolioImageView.userInteractionEnabled = YES;
    
    self.portfolioScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.portfolioImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Scroll View + Auto Layout Fix
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_portfolioScrollView,_portfolioImageView);
    [self.resumeView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_portfolioScrollView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.resumeView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_portfolioScrollView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.portfolioScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_portfolioImageView]|" options:0 metrics: 0 views:viewsDictionary]];
    [self.portfolioScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_portfolioImageView]|" options:0 metrics: 0 views:viewsDictionary]];
    
    thisServer = [[ServerIO alloc] init];
    thisServer.delegate = (id) self;
    
    [thisServer getUser:@"ZrgFJyD55e"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)returnData:(AFHTTPRequestOperation *)operation response:(NSDictionary *)response {
    if (operation.tag == GETUSER) {
        if ([[[[response objectForKey:@"response"] objectForKey:@"users"] objectAtIndex:0] objectForKey:@"resume"]) {;
            
            NSString *resumeLink = [[[[response objectForKey:@"response"] objectForKey:@"users"] objectAtIndex:0] objectForKey:@"resume"];
            
            // No resume uploaded
            if ([resumeLink isEqual: [NSNull null]]) {
                // User has no resume
                NSLog(@"User has no resume");
                return;
            }
            else {
                self.resumeLink = resumeLink;
            }
            
            self.resumeView.hidden = NO;
            
            NSLog(@"yeah getting user bro");
            
            int userIDInt = [[[[[response objectForKey:@"response"] objectForKey:@"users"] objectAtIndex:0] objectForKey:@"id"] intValue];
            NSString *userID = [NSString stringWithFormat:@"%i", userIDInt];
            self.portfolioImageView.contentMode = UIViewContentModeTopLeft;
            NSLog(@"resume link %@", resumeLink);
            
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
#warning To turn on mixpanel later
//            [mixpanel track:@"Downloaded Resume"];
            
            __weak PersonViewController *weakSelf = self;
            
            [self.portfolioImageView setImageWithURL:[NSURL URLWithString:resumeLink] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
                NSLog(@"image description %@", [image description]);
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                CGFloat screenWidth = screenRect.size.width;
                weakSelf.portfolioScrollView.contentSize = CGSizeMake(screenWidth, image.size.height);
                weakSelf.portfolioScrollView.zoomScale = screenWidth/image.size.width;
                weakSelf.portfolioScrollView.minimumZoomScale = screenWidth/image.size.width;
            } usingProgressView:nil];
        }
    }
}

- (void)returnFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    
}



#pragma mark - UIScrollView Delegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"Scrolled");
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //    NSLog(@"Zoomed");
    NSLog(@"my frame is %f %f", self.portfolioScrollView.frame.size.height, self.portfolioScrollView.frame.size.width);
    NSLog(@"my size is %f %f", self.portfolioScrollView.contentSize.height, self.portfolioScrollView.contentSize.width);
    NSLog(@"my zoomscale is %f", self.portfolioScrollView.zoomScale);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.portfolioImageView;
}

@end
