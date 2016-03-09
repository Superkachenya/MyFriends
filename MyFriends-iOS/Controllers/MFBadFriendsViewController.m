//
//  MFBadFriendsViewController.m
//  MyFriends-iOS
//
//  Created by Danil on 03.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFBadFriendsViewController.h"
#import "MFTableViewCell.h"
#import <MagicalRecord/MagicalRecord.h>
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
    
    self.fetchController = [MFFriend fetchWithMRFriend:NO];
    NSError *error = nil;
    [self.fetchController performFetch:&error];
    self.fetchController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [cell configureCellWithFriend:friend];
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MFFriend *removedFriend = [self.fetchController objectAtIndexPath:indexPath];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            MFFriend *localFriend = [removedFriend MR_inContext:localContext];
            [localFriend MR_deleteEntity];
        }];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray
                                                    arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray
                                                    arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - Custom methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (IBAction)forgiveButtonDidPress:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *tappedIP = [self.tableView indexPathForRowAtPoint:buttonPosition];
    MFFriend *forgivenFriend = [self.fetchController objectAtIndexPath:tappedIP];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        MFFriend *localFriend = [forgivenFriend MR_inContext:localContext];
        localFriend.friend = @YES;
    }];
}

- (void)configureCell:(MFTableViewCell *)cell {
    MFFriend *friend = [self.fetchController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    [cell configureCellWithFriend:friend];
}

@end
