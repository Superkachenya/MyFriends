//
//  MFTableViewCell.m
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFTableViewCell.h"
#import "MFFriend.h"
#import "MFUser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MFTableViewCell ()

@property (copy, nonatomic) GreenButtonDidPress didTapButtonBlock;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;

@end

@implementation MFTableViewCell

- (void)awakeFromNib {
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.width / 2;
    self.userPhoto.clipsToBounds = YES;
    self.userPhoto.layer.borderWidth = 1.0f;
    self.userPhoto.layer.borderColor = [UIColor purpleColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configureCellWithFriend:(MFFriend *)friend actionBlock:(GreenButtonDidPress)block{
    NSURL *url = [NSURL URLWithString:friend.photoThumbnail];
    [self.userPhoto sd_setImageWithURL:url];
    self.firstName.text = friend.firstName;
    self.lastName.text = friend.lastName;
    self.didTapButtonBlock = block;
}

- (void)configureCellWithUser:(MFUser *)user actionBlock:(GreenButtonDidPress)block{
    NSURL *url = [NSURL URLWithString:user.photoThumbnail];
    [self.userPhoto sd_setImageWithURL:url];
    self.firstName.text = user.firstName;
    self.lastName.text = user.lastName;
    self.didTapButtonBlock = block;
}

- (IBAction)addButtonDidPress:(id)sender {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock(sender);
    }
}

@end
