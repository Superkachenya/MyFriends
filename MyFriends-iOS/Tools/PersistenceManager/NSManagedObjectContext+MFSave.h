//
//  NSManagedObjectContext+MFSave.h
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef void(^ContextCompletionBlock)();

@interface NSManagedObjectContext (Save)

- (void)saveContext;

@end