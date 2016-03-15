//
//  MFFriendDetailsViewController.h
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFDetailsProtocol.h"

@interface MFFriendDetailsViewController : UIViewController

@property (strong, nonatomic) id<MFDetailsProtocol>details;

@end
