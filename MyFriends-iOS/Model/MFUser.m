//
//  MFUser.m
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFUser.h"
#import "FastEasyMapping.h"

@implementation MFUser

+ (FEMMapping *)defaultMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[MFUser class]];
    [mapping addAttributesFromArray:@[@"email"]];
    [mapping addAttributesFromArray:@[@"phone"]];
    [mapping addAttributeWithProperty:@"firstName" keyPath:@"name.first"];
    [mapping addAttributeWithProperty:@"lastName" keyPath:@"name.last"];
    [mapping addAttributeWithProperty:@"photoLarge" keyPath:@"picture.large"];
    [mapping addAttributeWithProperty:@"photoThumbnail" keyPath:@"picture.thumbnail"];
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
    return NO;
}

@end
