//
//  MFPersistenceManager.h
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MFPersistenceManager : NSObject

@property (strong, readonly) NSManagedObjectContext *mainContext;
@property (strong, readonly) NSManagedObjectContext *workerContext;

+ (instancetype)sharedManager;

@end

