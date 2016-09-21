//
//  APIManager.m
//  Shots
//
//  Created by Vincent Chau on 9/20/16.
//  Copyright © 2016 Vincent Chau. All rights reserved.
//

#import "APIManager.h"
#import "AppDelegate.h"

@implementation APIManager

+ (APIManager *)sharedInstance
{
    static APIManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIManager alloc] init];
    });
    
    return _sharedInstance;
}

+ (void)reteiveHomeShotsJSON:(NSString *)endpointUrl withCompletion:(void (^)(NSError *error, NSArray *cards, NSString *feedId))block
{
    NSURL *url = [NSURL URLWithString:endpointUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    [request setValue:@"abc123" forHTTPHeaderField:@"device-token"];
    [request setValue:@"ios" forHTTPHeaderField:@"client-name"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *cardTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error)
        {
            NSError *error;
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSDictionary *jsonDict = (NSDictionary *)responseJSON;
            NSArray *groups = (NSArray *)jsonDict[@"groups"];
            NSArray *allCards = ([(NSArray *)groups lastObject])[@"cards"];
            NSString *feedID = ([(NSArray *)groups lastObject])[@"feedId"];
            block(nil, allCards, feedID);
        }
        else
        {
            NSLog(@"%@",error.localizedDescription);
            block(error, nil, nil);
        }
        
    }];
    
    [cardTask resume];
}

+ (void)retreiveMoreFeedJSON:(NSString *)endpointUrl withCompletion:(void (^)(NSError *error, NSArray *cards, NSString *nextPage))block
{
    NSURL *url = [NSURL URLWithString:endpointUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    [request setValue:@"abc123" forHTTPHeaderField:@"device-token"];
    [request setValue:@"ios" forHTTPHeaderField:@"client-name"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *cardTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error)
        {
            NSError *error;
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSDictionary *groups = (NSDictionary *)responseJSON;
            NSArray *allCards = groups[@"cards"];
            NSString *nextPg = groups[@"nextPage"];
            
            block(error, allCards, nextPg);
        }
        else
        {
            block(error, nil, nil);
            NSLog(@"%@",error.localizedDescription);
        }
        
    }];
    
    [cardTask resume];
    
}


+ (void)downloadImagesWithUrl:(NSString *)url withCompletion:(void (^)(UIImage *image, bool success))block
{
    NSCache *imgCache = ((AppDelegate *)[UIApplication sharedApplication].delegate).imgCache;
    UIImage *current = [imgCache objectForKey:url];
    
    if (!current) // Not in cache
    {
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (response)
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (image != nil)
                        {
                            block(image, true);
                            [imgCache setObject:image forKey:url];
                        }
                        else // Corrupted jpg, use placeholder
                        {
                            UIImage *badImage = [UIImage imageNamed:@"badImage"];
                            [imgCache setObject:badImage forKey:url];
                            block(badImage, false);
                        }
                    });
                });
            }
        }];
        [task resume];

    }
    else // Image is in cache
    {
        block(current, true);
    }

}

@end
