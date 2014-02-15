//
//  PersonViewController.m
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/14/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import "PersonViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect tempRect = self.view.frame;
    tempRect.origin.y += 64;
    tempRect.size.height -= 64;
    self.portfolioScrollView = [[UIScrollView alloc] initWithFrame:tempRect];
    self.portfolioImageView = [[UIImageView alloc] initWithFrame:tempRect];
    [self.resumeView addSubview:self.portfolioScrollView];
    
    self.portfolioScrollView.clipsToBounds = YES;
    
    [self.portfolioScrollView addSubview:self.portfolioImageView];
    
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
