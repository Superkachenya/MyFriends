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
#import "MFStoryboardConstants.h"
#import "FastEasyMapping.h"
#import "MFFriendDetailsViewController.h"

@interface MFUsersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UIAlertController *alertController;

@end

@implementation MFUsersViewController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getMoreRandomUsers];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MFTableViewCell *cell = nil;
    if (indexPath.row == self.users.count) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kWaitForItIdentifier forIndexPath:indexPath];
        [cell.activity startAnimating];
    } else {
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
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.users count] - 1 ) {
        [self getMoreRandomUsers];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toDetailsVCFromUsersVC]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        MFFriendDetailsViewController *details = segue.destinationViewController;
        details.details = self.users [indexPath.row];
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
            if (!self.users) {
                self.users = [NSMutableArray new];
            }
            [self.users addObjectsFromArray:users];
            [self.tableView reloadData];
        }
    }];
}

@end
