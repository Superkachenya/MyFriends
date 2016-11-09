//
//  MFNetworkManager.m
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFNetworkManager.h"
#import "AFNetworking.h"
#import "MFUser.h"
#import "FastEasyMapping.h"

NSString *const url = @"http://api.randomuser.me/?results=100";

@implementation MFNetworkManager

+ (void)showRandomUsersWithCompletionBlock:(Completion)block {
    Completion copyBlock = [block copy];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil
        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass: [NSDictionary class]]) {
                NSMutableArray *users = [NSMutableArray new];
                NSArray *results = responseObject[@"results"];
                for (id randomUser in results) {
                    NSDictionary *currentUser = (NSDictionary *)randomUser;
                    FEMMapping *mapping = [MFUser defaultMapping];
                    MFUser *user = [FEMDeserializer objectFromRepresentation:currentUser mapping:mapping];
                    [users addObject:user];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    copyBlock (nil, users);
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error);
            copyBlock(error, nil);
        }];
}

@end
