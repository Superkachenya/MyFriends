//
//  ViewController.m
//  MyFriends-iOS
//
//  Created by Danil on 01.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFAllFriendsViewController.h"
#import "MFTableViewCell.h"
#import "MFFriendDetailsViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "MFFriend.h"
#import "MFStoryboardConstants.h"

@interface MFAllFriendsViewController () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation MFAllFriendsViewController

#pragma mark - UIViewlifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fetchController = [MFFriend fetchWithMRFriend:YES];
    NSError *error = nil;
    [self.fetchController performFetch:&error];
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController sections][0];
    if (![sectionInfo numberOfObjects]) {
        [self performSegueWithIdentifier:@"showUsers" sender:self];
    }
    self.fetchController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kAllFriendsCellIdentifier forIndexPath:indexPath];
    MFFriend *friend = [self.fetchController objectAtIndexPath:indexPath];
    [cell configureCellWithFriend:friend actionBlock:nil];
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MFFriend *badFriend = [self.fetchController objectAtIndexPath:indexPath];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            MFFriend *localFriend = [badFriend MR_inContext:localContext];
            localFriend.isFriend = @NO;
        }];
        
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toFriendDetailsVC]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        MFFriendDetailsViewController *details = segue.destinationViewController;
        details.friend = [self.fetchController objectAtIndexPath:indexPath];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - Custom methods

- (void)configureCell:(MFTableViewCell *)cell {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    MFFriend *friend = [self.fetchController objectAtIndexPath:indexPath];
    [cell configureCellWithFriend:friend actionBlock:nil];
}

@end
