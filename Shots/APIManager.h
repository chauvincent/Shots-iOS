//
//  APIManager.h
//  Shots
//
//  Created by Vincent Chau on 9/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APIManager : NSObject
{
    APIManager * sharedInstance;
    NSString *feedID;
}

+ (void)downloadImagesWithUrl:(NSString *)url withCompletion:(void (^)(UIImage *image, bool success))block;
+ (void)reteiveHomeShotsJSON:(NSString *)endpointUrl withCompletion:(void (^)(NSError *error, NSArray *cards, NSString *feedId))block;
+ (void)retreiveMoreFeedJSON:(NSString *)endpointUrl withCompletion:(void (^)(NSError *error, NSArray *cards, NSString *nextPage))block;

@end
