//
//  MFBadFriendsViewController.m
//  MyFriends-iOS
//
//  Created by Danil on 03.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFBadFriendsViewController.h"
#import "MFTableViewCell.h"
#import "MFFriendDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MFPersistenceManager.h"
#import "NSManagedObjectContext+MFSave.h"
#import <CoreData/CoreData.h>
#import "MFFriend.h"

@interface MFBadFriendsViewController () <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation MFBadFriendsViewController 

#pragma mark - UIViewlifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [MFPersistenceManager sharedManager].mainContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MFFriend"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"friend == NO"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    self.fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                               managedObjectContext:self.context sectionNameKeyPath:nil
                                                                          cacheName:nil];
    NSError *error = nil;
    [self.fetchController performFetch:&error];
    self.fetchController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const reuseIdentifier = @"badFriendCell";
    MFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    MFFriend *friend = [self.fetchController objectAtIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:friend.photoThumbnail];
    [cell.userPhoto sd_setImageWithURL:url
                      placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    cell.firstName.text = friend.firstName;
    cell.lastName.text = friend.lastName;
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MFFriend *forgivenFriend = [self.fetchController objectAtIndexPath:indexPath];
    forgivenFriend.friend = @YES;
    [self.context saveWithCompletionBlock:^{
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.context deleteObject:[self.fetchController objectAtIndexPath:indexPath]];
        [self.context saveWithCompletionBlock:^{
        }];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
