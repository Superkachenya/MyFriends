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
#import <SDWebImage/UIImageView+WebCache.h>
#import "MFPersistenceManager.h"
#import "NSManagedObjectContext+MFSave.h"
#import <CoreData/CoreData.h>
#import "MFFriend.h"

@interface MFAllFriendsViewController () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation MFAllFriendsViewController

#pragma mark - UIViewlifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [MFPersistenceManager sharedManager].mainContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MFFriend"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"friend == YES"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    self.fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                               managedObjectContext:self.context sectionNameKeyPath:nil
                                                                          cacheName:nil];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.context saveContext];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const reuseIdentifier = @"friendCell";
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MFFriend *badFriend = [self.fetchController objectAtIndexPath:indexPath];
        badFriend.friend = @NO;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFriend"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        UINavigationController *naviController = segue.destinationViewController;
        MFFriendDetailsViewController *details = naviController.viewControllers.firstObject;
        details.friend = [self.fetchController objectAtIndexPath:indexPath];
    }
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
