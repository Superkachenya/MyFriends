//
//  User.m
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFFriend.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation MFFriend

+ (NSFetchedResultsController *)fetchWithMRFriend:(BOOL)friend {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"friend == %c", friend];
    NSFetchedResultsController *results = [MFFriend MR_fetchAllGroupedBy:nil
                                                           withPredicate:predicate
                                                                sortedBy:@"firstName"
                                                               ascending:YES];
    return results;
}

@end
