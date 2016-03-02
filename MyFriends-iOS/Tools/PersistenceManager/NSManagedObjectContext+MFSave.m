//
//  NSManagedObjectContext+MFSave.m
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "NSManagedObjectContext+MFSave.h"

@implementation NSManagedObjectContext (Save)

- (void)saveWithCompletionBlock:(ContextCompletionBlock)block {
    ContextCompletionBlock copyContextBlock = [block copy];
    if ([self hasChanges]) {
        [self performBlock: ^{
            NSError *error = nil;
            [self save:&error];
            [self.parentContext saveWithCompletionBlock:^{
            }];
            copyContextBlock();
            NSLog(@"\n\n\nContext saved %@\n\n\n", self);
        }];
    }
}

@end