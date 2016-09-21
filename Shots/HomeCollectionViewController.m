//
//  ShotsHomeCollectionViewController.m
//  Shots
//
//  Created by Vincent Chau on 9/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "HomeCollectionViewController.h"
#import "ShotCollectionViewCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JSONParser.h"
#import "Card.h"
#import "APIManager.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface HomeCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSString *feedId;
@property (strong, nonatomic) NSString *nextPage;
@property (strong, nonatomic) JSONParser *parser;

@end

@implementation HomeCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - Lazy Initializations

- (JSONParser *)parser
{
    if (!_parser) {
        _parser = [[JSONParser alloc] init];
    }
    return _parser;
}

- (NSMutableArray *)cards
{
    if (!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self loadTestJSON];
    [self setupView];
    [self setupHomeFeed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup View

- (void)setupView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:244.0/255.0f green:244.0/255.0f blue:244.0/255.0f alpha:1.0f];
    [self.collectionView registerClass:[ShotCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView setContentInset:UIEdgeInsetsMake(0,0,75,0)];
    
    self.navigationItem.title = @"Shots";
    self.navigationController.hidesBarsOnSwipe = TRUE;
}

#pragma mark - Setup Cards

- (void)setupHomeFeed
{
    NSString *url = @"https://api.staging.kamcord.com/v1/feed/set/featuredShots?count=20";
    [APIManager reteiveHomeShotsJSON:url withCompletion:^(NSError *error, NSArray *cards, NSString *feedId, NSString *nextPage) {
        
        if (!error)
        {
            dispatch_queue_t q = dispatch_queue_create("Parse JSON Queue", NULL);
            dispatch_async(q, ^{
                [self.parser parseCardJSONWithCardsDict:cards withCompletion:^(NSMutableArray *cards) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.cards = cards;
                        [self.collectionView reloadData];
                    });
                    
                }];
            });
            self.feedId = feedId;
            self.nextPage = nextPage;
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)loadMoreCards
{

    if (self.feedId != nil && self.nextPage != nil)
    {
        NSString *url = [NSString stringWithFormat:@"https://api.staging.kamcord.com/v1/feed/%@/?count=20&page=%@", self.feedId, self.nextPage];
        
        [APIManager retreiveMoreFeedJSON:url withCompletion:^(NSError *error, NSArray *cards, NSString *nextPage) {
            
            if (!error)
            {
                dispatch_queue_t q = dispatch_queue_create("Parse Queue", NULL);
                dispatch_async(q, ^{
                    [self.parser parseCardJSONWithCardsDict:cards withCompletion:^(NSMutableArray *cards) {
                        dispatch_async(dispatch_get_main_queue(),  ^{
                            
                            for (Card* card in cards)
                            {
                                [self.cards addObject:card];
                            }
                            self.nextPage = nextPage;
                            [self.collectionView reloadData];
                        });
                    }];
                });
            }
            else
            {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShotCollectionViewCell *cell = (ShotCollectionViewCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    [cell configureCellWith:self.cards[indexPath.row]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    float paddingOffset = 5.0;
    
    if ( IDIOM == IPAD )
    {
        size = collectionView.frame.size;
        size.width = (size.width / 5.0) - paddingOffset;
        size.height = (size.height / 4.0) - paddingOffset;
    }
    else
    {
        size = collectionView.frame.size;
        size.width = (size.width / 3.0) - paddingOffset;
        size.height = (size.height / 4.0) - paddingOffset;
    }
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Card *card = self.cards[indexPath.row];
    NSURL *videoUrl = [NSURL URLWithString:card.videoUrl];
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = [[AVPlayer alloc] initWithURL:videoUrl];
    
    [self presentViewController:playerVC animated:YES completion:^{
        [playerVC.player play];
    }];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    if (endScrolling >= scrollView.contentSize.height)
    {
        [self loadMoreCards];
    }
}

/*
 
#pragma mark - Testing Purposes: Load JSON from testing file to test parser

- (void)loadTestJSON
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testJSON" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    NSArray *groups = (NSArray *)jsonDict[@"groups"];
    NSArray *allCards = ([(NSArray *)groups lastObject])[@"cards"];
    
    JSONParser *parser = [[JSONParser alloc] init];
    [parser parseCardJSONWithCardsDict:allCards withCompletion:^(NSMutableArray *cards) {
        for (Card *card in cards) {
            NSLog(@"%@", card.heartCount);
            [self.collectionView reloadData];
        }
    }];
    
}
*/
@end
