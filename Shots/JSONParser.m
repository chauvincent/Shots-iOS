//
//  JSONParser.m
//  Shots
//
//  Created by Vincent Chau on 9/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

- (void)parseCardJSONWithCardsDict:(NSArray *)cardDict withCompletion:(void (^)(NSMutableArray *cards))block
{
    NSMutableArray *allCards = [[NSMutableArray alloc] init];
    
    for (NSDictionary *cardInfo in cardDict)
    {
        NSDictionary *shotCardData = cardInfo[@"shotCardData"];
        NSString *heartCount = shotCardData[@"heartCount"];
        NSString *thumbnailUrl = shotCardData[@"shotThumbnail"][@"medium"];
        NSString *videoUrl = shotCardData[@"play"][@"mp4"];
        
        Card *card = [[Card alloc] initWithHeartCount:heartCount thumbImgUrl:thumbnailUrl videoUrl:videoUrl];
        [allCards addObject:card];
    }
    
    block(allCards);
}


@end
