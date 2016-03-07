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
#import "MFPersistenceManager.h"
#import "NSManagedObjectContext+MFSave.h"
#import <CoreData/CoreData.h>
#import "MFFriend.h"
#import "SVProgressHUD.h"

@interface MFUsersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation MFUsersViewController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    self.context = [MFPersistenceManager sharedManager].workerContext;
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
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.context saveContext];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const reuseIdentifier = @"userCell";
    MFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    MFUser *user = self.users[indexPath.row];
    [cell configureCellWithUser:user];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MFUser *user = self.users[indexPath.row];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MFFriend"];
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"email == %@",user.email];
    MFFriend *newFriend = nil;
    newFriend = [self.context executeFetchRequest:fetchRequest
                                            error:nil].firstObject;
    if (!newFriend) {
        newFriend = [NSEntityDescription insertNewObjectForEntityForName:@"MFFriend"
                                                  inManagedObjectContext:self.context];
        newFriend.firstName = user.firstName;
        newFriend.lastName = user.lastName;
        newFriend.email = user.email;
        newFriend.phone = user.phone;
        newFriend.photoLarge = user.photoLarge;
        newFriend.photoThumbnail = user.photoThumbnail;
        newFriend.friend = @YES;
    }
    [self.users removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];

}

- (IBAction)addUserButtonDidPress:(id)sender {
}

@end
