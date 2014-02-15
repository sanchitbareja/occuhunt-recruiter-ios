//
//  PersonViewController.h
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/14/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *resumeView;
@property (nonatomic, strong) IBOutlet UIScrollView *portfolioScrollView;
@property (nonatomic, strong) IBOutlet UIImageView *portfolioImageView;

@end
