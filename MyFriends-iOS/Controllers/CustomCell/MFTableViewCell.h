//
//  MFTableViewCell.h
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MFFriend, MFUser;

typedef void(^GreenButtonDidPress)(id sender);

@interface MFTableViewCell : UITableViewCell

- (void)configureCellWithFriend:(MFFriend *)friend actionBlock:(GreenButtonDidPress)block;
- (void)configureCellWithUser:(MFUser *)user actionBlock:(GreenButtonDidPress)block;

@end
