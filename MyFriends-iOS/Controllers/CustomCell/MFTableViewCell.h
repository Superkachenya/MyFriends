//
//  MFTableViewCell.h
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MFFriend, MFUser;

@interface MFTableViewCell : UITableViewCell

- (void)configureCellWithFriend:(MFFriend *)friend atRow:(NSInteger)row ;
- (void)configureCellWithUser:(MFUser *)user atRow:(NSInteger)row;

@end
