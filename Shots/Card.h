//
//  Card.h
//  Shots
//
//  Created by Vincent Chau on 9/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *thumbnailImgUrl;
@property (strong, nonatomic) NSString *videoUrl;
@property (strong, nonatomic) NSString *heartCount;


- (instancetype)initWithHeartCount:(NSString *)count thumbImgUrl:(NSString *)thumbnailUrl videoUrl:(NSString *)videoUrl;

@end
