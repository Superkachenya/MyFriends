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
#import <MagicalRecord/MagicalRecord.h>

@interface MFFriendDetailsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet TSValidatedTextField *phone;
@property (weak, nonatomic) IBOutlet TSValidatedTextField *email;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (assign, nonatomic) CGFloat layoutConstant;

@end

@implementation MFFriendDetailsViewController

#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scrollView setContentOffset: CGPointMake(0, self.scrollView.contentOffset.y)];
    self.scrollView.directionalLockEnabled = YES;
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.width / 2;
    self.userPhoto.clipsToBounds = YES;
    self.userPhoto.layer.borderWidth = 1.0f;
    self.userPhoto.layer.borderColor = [UIColor purpleColor].CGColor;
    self.phone.delegate = self;
    self.email.delegate = self;
    self.layoutConstant = self.bottomConstraint.constant;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSURL *url = [NSURL URLWithString:self.friend.photoLarge];
    [self.userPhoto sd_setImageWithURL:url
                      placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    self.firstName.text = self.friend.firstName;
    self.lastName.text = self.friend.lastName;
    self.email.text = self.friend.email;
    self.phone.text = self.friend.phone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - BarButtons methods

- (IBAction)cancelButtonDidPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonDidPress:(id)sender {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        MFFriend *localFriend = [self.friend MR_inContext:localContext];
        localFriend.phone = self.phone.text;
        localFriend.email = self.email.text;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - TextFields methods

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

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.bottomConstraint.constant = kbSize.height /2;

}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    self.bottomConstraint.constant = self.layoutConstant;

}

@end
