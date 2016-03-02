//
//  MFNetworkManager.h
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Completion)(NSError *error, NSMutableArray *users);

@interface MFNetworkManager : NSObject

+ (void)showRandomUsersWithCompletionBlock:(Completion)block;

@end
