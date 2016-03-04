//
//  User.m
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFFriend.h"
#import "MFPersistenceManager.h"

@implementation MFFriend

+ (NSFetchedResultsController *)fetchedResultControllerWithFriend:(BOOL)flag {
    NSManagedObjectContext *context = [MFPersistenceManager sharedManager].mainContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MFFriend"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"friend == %c", flag];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSFetchedResultsController *results= [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                             managedObjectContext:context
                                                                               sectionNameKeyPath:nil
                                                                                        cacheName:nil];
    return results;
}

@end
