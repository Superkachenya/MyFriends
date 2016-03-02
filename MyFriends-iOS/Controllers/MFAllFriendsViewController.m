//
//  ViewController.m
//  MyFriends-iOS
//
//  Created by Danil on 01.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFAllFriendsViewController.h"
#import "MFTableViewCell.h"

@interface MFAllFriendsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MFAllFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const reuseIdentifier = @"friendCell";
    MFTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

@end
