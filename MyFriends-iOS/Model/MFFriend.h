//
//  User.h
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFFriend : NSManagedObject

+ (NSFetchedResultsController *)fetchedResultControllerWithFriend:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END

#import "MFFriend+CoreDataProperties.h"
