//
//  Card.m
//  Shots
//
//  Created by Vincent Chau on 9/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "Card.h"

@implementation Card

- (instancetype)initWithHeartCount:(NSString *)count thumbImgUrl:(NSString *)thumbnailUrl videoUrl:(NSString *)videoUrl
{
  
    if (self = [super init])
    {
        _heartCount = count;
        _thumbnailImgUrl = thumbnailUrl;
        _videoUrl = videoUrl;
    }
    
    return self;
}

@end
