//
//  User.m
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFFriend.h"
#import <MagicalRecord/MagicalRecord.h>
#import "FastEasyMapping.h"

@implementation MFFriend

+ (NSFetchedResultsController *)fetchWithMRFriend:(BOOL)isFriend {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFriend == %c", isFriend];
    NSFetchedResultsController *results = [MFFriend MR_fetchAllGroupedBy:nil
                                                           withPredicate:predicate
                                                                sortedBy:@"firstName"
                                                               ascending:YES];
    return results;
}

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"MFFriend"];
    [mapping addAttributesFromArray:@[@"email"]];
    [mapping addAttributesFromArray:@[@"phone"]];
    [mapping addAttributesFromArray:@[@"firstName"]];
    [mapping addAttributesFromArray:@[@"lastName"]];
    [mapping addAttributesFromArray:@[@"photoLarge"]];
    [mapping addAttributesFromArray:@[@"photoThumbnail"]];
    return mapping;
}

#pragma mark - MFDetailsProtocol
- (NSString *)getEmail {
    return self.email;
}

- (NSString *)getPhone {
    return self.phone;
}

- (NSString *)getFirstName {
    return self.firstName;
}

- (NSString *)getLastName {
    return self.lastName;
}

- (NSString *)getPhotoLarge {
    return self.photoLarge;
}

- (BOOL)isEditable {
    return YES;
}
@end
