//
//  MFFriendDetailsViewController.m
//  MyFriends-iOS
//
//  Created by Danil on 02.03.16.
//  Copyright © 2016 Cleveroad. All rights reserved.
//

#import "MFFriendDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MFFriend.h"
#import "TSValidatedTextField.h"
#import "MFPersistenceManager.h"
#import "NSManagedObjectContext+MFSave.h"

@interface MFFriendDetailsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet TSValidatedTextField *phone;
@property (weak, nonatomic) IBOutlet TSValidatedTextField *email;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation MFFriendDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.width / 2;
    self.userPhoto.clipsToBounds = YES;
    self.userPhoto.layer.borderWidth = 1.0f;
    self.userPhoto.layer.borderColor = [UIColor purpleColor].CGColor;
    self.phone.delegate = self;
    self.email.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSURL *url = [NSURL URLWithString:self.friend.photoLarge];
    [self.userPhoto sd_setImageWithURL:url
                      placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    self.firstName.text = self.friend.firstName;
    self.lastName.text = self.friend.lastName;
    self.email.text = self.friend.email;
    self.phone.text = self.friend.phone;
}

- (IBAction)cancelButtonDidPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonDidPress:(id)sender {
    self.friend.phone = self.phone.text;
    self.friend.email = self.email.text;
    NSManagedObjectContext *context = [MFPersistenceManager sharedManager].mainContext;
    [context saveWithCompletionBlock:^{
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)userDidTap:(id)sender {
    [self.phone resignFirstResponder];
    [self.email resignFirstResponder];
}

- (IBAction)phoneEditingDidBegin:(id)sender {
    self.phone.regexpPattern = @"\\d{3}-\\d{3}-\\d{3}";
    self.phone.regexpValidColor = [UIColor greenColor];
    self.phone.regexpInvalidColor = [UIColor redColor];
    self.phone.minimalNumberOfCharactersToStartValidation = 11;
    self.phone.validWhenType = NO;
    self.phone.validatedFieldBlock = ^(ValidationResult result, BOOL isEditing) {
        switch (result) {
            case ValidationPassed:
                self.doneButton.enabled = YES;
                break;
            case ValidationFailed:
                self.doneButton.enabled = NO;
                break;
            case ValueTooShortToValidate:
                self.doneButton.enabled = NO;
                break;
        }
    };
}

- (IBAction)emailEditingDidBegin:(id)sender {
    self.email.regexpValidColor = [UIColor greenColor];
    self.email.regexpInvalidColor = [UIColor redColor];
    self.email.regexpPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    self.email.validWhenType = NO;
    self.email.validatedFieldBlock = ^(ValidationResult result, BOOL isEditing) {
        switch (result) {
            case ValidationPassed:
                self.doneButton.enabled = YES;
                break;
            case ValidationFailed:
                self.doneButton.enabled = NO;
                break;
            case ValueTooShortToValidate:
                self.doneButton.enabled = NO;
                break;
        }
    };
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.phone resignFirstResponder];
    [self.email resignFirstResponder];
    return YES;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
