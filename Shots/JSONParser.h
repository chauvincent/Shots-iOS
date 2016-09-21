//
//  JSONParser.h
//  Shots
//
//  Created by Vincent Chau on 9/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface JSONParser : NSObject

- (void)parseCardJSONWithCardsDict:(NSArray *)cardDict withCompletion:(void (^)(NSMutableArray *cards))block;

@end
