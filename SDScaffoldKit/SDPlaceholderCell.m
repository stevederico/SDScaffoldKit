//
//  SDTextFieldCell.m
//  SDKit
//
//  Created by Steve Derico on 9/20/11.
//  Copyright 2011 Bixby Apps. All rights reserved.
//


#import "SDPlaceholderCell.h"

@implementation SDPlaceholderCell

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect origFrame = self.contentView.frame;
	if (self.textField.text != nil) {
        self.textField.hidden = NO;
        self.textField.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.size.width-20, origFrame.size.height-1);
        
	} else {
		self.textField.hidden = YES;
		NSInteger imageWidth = 0;
		if (self.imageView.image != nil) {
			imageWidth = self.imageView.image.size.width + 5;
		}
		self.textField.frame = CGRectMake(origFrame.origin.x+imageWidth+10, origFrame.origin.y, origFrame.size.width-imageWidth-20, origFrame.size.height-1);
	}
    
    [self setNeedsDisplay];
}



@end
