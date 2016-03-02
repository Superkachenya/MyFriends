//
//  MFNetworkManager.m
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFNetworkManager.h"
#import "AFNetworking.h"

NSString *const url = @"http://api.randomuser.me/?results=2000";

@implementation MFNetworkManager

+ (void)showRandomUsers {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil
        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);

    }];
}

@end
