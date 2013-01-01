//
//  SDTextFieldCell.m
//  SDKit
//
//  Created by Steve Derico on 9/20/11.
//  Copyright 2011 Bixby Apps. All rights reserved.
// Thanks to ELCTextFieldCell.m for the improvements!


#import "SDTextFieldCell.h"

@implementation SDTextFieldCell
@synthesize textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_textField setFont:[UIFont systemFontOfSize:17]];
        _textField.clearsOnBeginEditing = NO;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_textField setDelegate:self];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    CGRect origFrame = self.contentView.frame;
	if (_textField.text != nil) {
        _textField.hidden = NO;
		_textField.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, 125, origFrame.size.height-1);
		_textField.frame = CGRectMake(origFrame.origin.x+130, origFrame.origin.y, origFrame.size.width-140, origFrame.size.height);
        
	} else {
		_textField.hidden = YES;
		NSInteger imageWidth = 0;
		if (self.imageView.image != nil) {
			imageWidth = self.imageView.image.size.width + 5;
		}
		_textField.frame = CGRectMake(origFrame.origin.x+imageWidth+10, origFrame.origin.y, origFrame.size.width-imageWidth-20, origFrame.size.height-1);
	}
    
    [self setNeedsDisplay];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    BOOL ret = YES;
	if([_delegate respondsToSelector:@selector(textFieldCell:shouldReturnForIndexPath:withValue:)]) {
        ret = [_delegate textFieldCell:self shouldReturnForIndexPath:_indexPath withValue:self.textField.text];
	}
    if(ret) {
        [textField resignFirstResponder];
    }
    return ret;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *textString = self.textField.text;
	textString = [textString stringByReplacingCharactersInRange:range withString:string];
	
	if([_delegate respondsToSelector:@selector(textFieldCell:updateTextLabelAtIndexPath:string:)]) {
		[_delegate textFieldCell:self updateTextLabelAtIndexPath:_indexPath string:textString];
	}
	
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if([_delegate respondsToSelector:@selector(updateTextLabelAtIndexPath:string:)]) {
		[_delegate performSelector:@selector(updateTextLabelAtIndexPath:string:) withObject:_indexPath withObject:nil];
	}
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
		return [_delegate textFieldShouldBeginEditing:(UITextField *)textField];
	}
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if([_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
		return [_delegate textFieldShouldEndEditing:(UITextField *)textField];
	}
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if([_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
		return [_delegate textFieldDidBeginEditing:(UITextField *)textField];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate textFieldDidEndEditing:(UITextField*)textField];
    }
}

- (void)dealloc {
    _delegate = nil;
    [_textField resignFirstResponder];
    
    
}


@end
