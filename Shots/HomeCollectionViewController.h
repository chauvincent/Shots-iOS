//
//  ShotsHomeCollectionViewController.h
//  Shots
//
//  Created by Vincent Chau on 9/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSString *feedId;
@property (strong, nonatomic) NSString *nextPage;

@end
