//
//  ShotCollectionViewCell.m
//  Shots
//
//  Created by Vincent Chau on 9/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "ShotCollectionViewCell.h"
#import "APIManager.h"

@implementation ShotCollectionViewCell


- (UIImageView *)imageView
{
    
    if (!_imageView)
    {
        CGSize contentSize = self.contentView.bounds.size;
        CGRect contentBounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
        
        _imageView = [[UIImageView alloc] initWithFrame:contentBounds];
        
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

- (UILabel *)likesLabel
{
    
    if (!_likesLabel)
    {
        CGSize contentSize = self.contentView.bounds.size;
        CGRect contentBounds = CGRectMake(0, contentSize.height - self.likesLabelHeight, contentSize.width, self.likesLabelHeight);
        
        _likesLabel = [[UILabel alloc] initWithFrame:contentBounds];
        _likesLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _likesLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _likesLabel.numberOfLines = 1;
        _likesLabel.textAlignment = NSTextAlignmentCenter;
        _likesLabel.backgroundColor = [UIColor whiteColor];
        _likesLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return _likesLabel;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.likesLabelHeight = 20.0f;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.likesLabel];
    }
    
    return self;
}

- (void)configureCellWith:(Card *)card
{
    [self addStyling];
    
    [APIManager downloadImagesWithUrl:card.thumbnailImgUrl withCompletion:^(UIImage *image, bool success) {
        self.imageView.image = image;
        self.likesLabel.text = [NSString stringWithFormat:@"♡ %@", card.heartCount];
    }];
}

- (void)addStyling
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 9.0f;
    self.layer.borderWidth = 0.1f;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}

@end
