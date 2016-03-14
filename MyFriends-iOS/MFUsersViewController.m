//
//  MFUsersViewController.m
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFUsersViewController.h"
#import "MFTableViewCell.h"
#import "MFNetworkManager.h"
#import "MFUser.h"
#import <MagicalRecord/MagicalRecord.h>
#import "MFFriend.h"
#import "SVProgressHUD.h"
#import "MFStoryboardConstants.h"
#import "FastEasyMapping.h"

@interface MFUsersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UIAlertController *alertController;

@end

@implementation MFUsersViewController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    self.users = [NSMutableArray new];
    [self getMoreRandomUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MFTableViewCell *cell = nil;
    if (indexPath.row == self.users.count) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kWaitForItIdentifier forIndexPath:indexPath];
        [cell.activity startAnimating];
    }
    cell = [self.tableView dequeueReusableCellWithIdentifier:kUserCellIdentifier forIndexPath:indexPath];
    MFUser *user = self.users[indexPath.row];
    __weak MFUsersViewController *weakSelf = self;
    FEMMapping *mapping = [MFFriend defaultMapping];
    [cell configureCellWithUser:user actionBlock:^(id sender) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            MFFriend *newFriend = [FEMDeserializer objectFromRepresentation:(NSDictionary*)user
                                                                    mapping:mapping
                                                                    context:localContext];
            newFriend.isFriend = @YES;
        }];
        [weakSelf.users removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView reloadData];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.users count] - 1 ) {
        [self getMoreRandomUsers];
    }
}
#pragma mark - Network connection

- (void)getMoreRandomUsers {
    [MFNetworkManager showRandomUsersWithCompletionBlock:^(NSError *error, NSMutableArray *users) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [alert dismissViewControllerAnimated:YES
                                                                                         completion:nil];
                                                           }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self.users addObjectsFromArray:users];
            [self.tableView reloadData];
        }
    }];
    
}

@end