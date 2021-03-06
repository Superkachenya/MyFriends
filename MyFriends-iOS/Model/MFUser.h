//
//  MFUser.h
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFDetailsProtocol.h"

@class FEMMapping;

@interface MFUser : NSObject <MFDetailsProtocol>

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *photoLarge;
@property (strong, nonatomic) NSString *photoThumbnail;

+ (FEMMapping *)defaultMapping;

@end
