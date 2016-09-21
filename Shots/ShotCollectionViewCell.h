//
//  ShotCollectionViewCell.h
//  Shots
//
//  Created by Vincent Chau on 9/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"


@interface ShotCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *likesLabel;
@property (nonatomic) CGFloat likesLabelHeight;

- (void)configureCellWith:(Card *)card;

@end
