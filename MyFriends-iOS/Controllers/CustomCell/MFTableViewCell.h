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

@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;

- (void)configureCellWithFriend:(MFFriend *)friend;
- (void)configureCellWithUser:(MFUser *)user;

@end
