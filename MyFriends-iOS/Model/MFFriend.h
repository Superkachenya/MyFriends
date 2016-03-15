//
//  User.h
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MFDetailsProtocol.h"
@class FEMMapping;

NS_ASSUME_NONNULL_BEGIN

@interface MFFriend : NSManagedObject <MFDetailsProtocol>

+ (NSFetchedResultsController *)fetchWithMRFriend:(BOOL)friend;
+ (FEMMapping *)defaultMapping;

@end

NS_ASSUME_NONNULL_END

#import "MFFriend+CoreDataProperties.h"
