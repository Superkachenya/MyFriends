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

@interface MFUsersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation MFUsersViewController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMoreRandomUsers];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor cyanColor];
    self.refreshControl.tintColor = [UIColor purpleColor];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(getMoreRandomUsers)
                  forControlEvents:UIControlEventValueChanged];
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
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const reuseIdentifier = @"userCell";
    MFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    MFUser *user = self.users[indexPath.row];
    [cell configureCellWithUser:user atRow:indexPath.row];
    return cell;
}

#pragma mark - Custom methods

- (IBAction)addUserButtonDidPress:(UIButton *)sender {
    MFUser *user = self.users[sender.tag];
    NSLog(@"%ld",(long)sender.tag);
    NSLog(@"%lu",(unsigned long)[self.users count]);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            MFFriend *newFriend = [MFFriend MR_createEntityInContext:localContext];
            newFriend.firstName = user.firstName;
            newFriend.lastName = user.lastName;
            newFriend.email = user.email;
            newFriend.phone = user.phone;
            newFriend.photoLarge = user.photoLarge;
            newFriend.photoThumbnail = user.photoThumbnail;
            newFriend.friend = @YES;
        }];
        [self.users removeObjectAtIndex:sender.tag];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (void)getMoreRandomUsers {
    if (!self.refreshControl) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
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
            self.users = users;
            if (self.refreshControl) {
                [self.refreshControl endRefreshing];
            }
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
    }];
    
}

@end