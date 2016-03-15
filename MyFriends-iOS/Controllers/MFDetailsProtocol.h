//
//  MFDetailsProtocol.h
//  MyFriends-iOS
//
//  Created by Danil on 15.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MFDetailsProtocol <NSObject>

- (NSString *)getEmail;
- (NSString *)getPhone;
- (NSString *)getFirstName;
- (NSString *)getLastName;
- (NSString *)getPhotoLarge;
- (BOOL)isEditable;

@end
