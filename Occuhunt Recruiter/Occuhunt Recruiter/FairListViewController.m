//
//  FairListViewController.m
//  Occuhunt Recruiter
//
//  Created by Sidwyn Koh on 2/14/14.
//  Copyright (c) 2014 Occuhunt. All rights reserved.
//

#import "FairListViewController.h"
#import "SharpLabel.h"
#import "ServerIO.h"

@interface FairListViewController ()

@end

@implementation FairListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UCB Startup Fair";
    
    UIBarButtonItem *fairButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Events" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = fairButtonItem;
    
    CGRect myView = self.view.frame;
    myView.origin.y += 20;
    myView.size.height -= 20;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:myView collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.userInteractionEnabled = YES;
    [self.view addSubview:_collectionView];
    
    self.listOfAttendees = [[NSArray alloc] init];
    
    thisServer = [[ServerIO alloc] init];
    thisServer.delegate = self;
    
    [thisServer getAttendees:@"8"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ServerIO Delegate Methods

- (void)returnData:(AFHTTPRequestOperation *)operation response:(NSDictionary *)response {
    if (operation.tag == GETATTENDEES) {
        if ([[response objectForKey:@"response"] objectForKey:@"applications"]) {
            self.listOfAttendees = [[[response objectForKey:@"response"] objectForKey:@"applications"] copy];
        }
        [self.collectionView reloadData];
    }
}

- (void)returnFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    
}


#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listOfAttendees.count;
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    SharpLabel *attendeeName;
    if ([cell.contentView viewWithTag:100]) {
        attendeeName = (SharpLabel *) [cell.contentView viewWithTag:100];
        attendeeName.text = @"";
    }
    else {
        attendeeName = [[SharpLabel alloc] initWithFrame:CGRectMake(2, 60, 138, 20)];
        attendeeName.tag = 100;
        attendeeName.textAlignment = NSTextAlignmentCenter;
        attendeeName.backgroundColor = [UIColor clearColor];
        attendeeName.font = [UIFont fontWithName:@"Proxima Nova" size:16];
        attendeeName.textColor = [UIColor blackColor];
        attendeeName.lineBreakMode = NSLineBreakByWordWrapping;
        attendeeName.numberOfLines = 0;
        
        CATiledLayer *tiledLayer = (CATiledLayer*)attendeeName.layer;
        tiledLayer.levelsOfDetail = 10;
        tiledLayer.levelsOfDetailBias = 10;
    }
    attendeeName.text = [[[self.listOfAttendees objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"first_name"];
    cell.backgroundColor = UIColorFromRGB(0xeef7f7);
    cell.layer.borderColor = [UIColorFromRGB(0xadadad) CGColor];
    cell.layer.borderWidth = 0.5f;
    [cell.contentView addSubview:attendeeName];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(140, 140);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected");
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
    
}

@end
