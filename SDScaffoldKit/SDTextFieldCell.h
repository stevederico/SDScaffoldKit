//
//  SDTextFieldCell.h
//  SDKit
//
//  Created by Steve Derico on 9/20/11.
//  Copyright 2011 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDTextFieldCell;

@protocol SDTextFieldCellDelegate <NSObject>

@optional

//Called to the delegate whenever return is hit when a user is typing into the rightTextField of an SDTextFieldCell
- (BOOL)textFieldCell:(SDTextFieldCell *)inCell shouldReturnForIndexPath:(NSIndexPath*)inIndexPath withValue:(NSString *)inValue;

//Called to the delegate whenever the text in the textField is changed
- (void)textFieldCell:(SDTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)inIndexPath string:(NSString *)inValue;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end

/**
 SDTextFieldCell
 
 Provides a UITextField inside a UITableViewCell, accessable through the native `textField` property.
 
 The UITextField instance is aligned to the right side of the cell, but UITextField text is aligned to the left.
 
 This class has no SelectionStyle by design, this would interfere with user input.
 
 The designated initializer for this class is initWithStyle:reuseIdentifier:
 */

@interface SDTextFieldCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, weak) id <SDTextFieldCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

