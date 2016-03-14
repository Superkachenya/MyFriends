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
    self.users = [NSMutableArray new];
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
    MFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUserCellIdentifier forIndexPath:indexPath];
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

#pragma mark - Network connection

- (void)getMoreRandomUsers {
    if (!self.refreshControl) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    [MFNetworkManager showRandomUsersWithCompletionBlock:^(NSError *error, NSMutableArray *users) {
        if (error) {
            [SVProgressHUD dismiss];
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
            if (self.refreshControl) {
                [self.refreshControl endRefreshing];
            }
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - (self.tableView.frame.size.height);
    if (actualPosition >= contentHeight) {
        [self getMoreRandomUsers];
    }
}
@end