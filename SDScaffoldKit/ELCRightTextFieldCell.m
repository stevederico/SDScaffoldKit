//
//  ELCTextFieldCell.m
//  ELC Utility
//
//  Copyright 2012 ELC Tech. All rights reserved.
//

#import "ELCRightTextFieldCell.h"

@implementation ELCRightTextFieldCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	CGRect origFrame = self.contentView.frame;
    NSInteger imageWidth = 0;
    if (self.imageView.image != nil) {
        imageWidth = self.imageView.image.size.width + 5;
    }
    self.rightTextField.textAlignment = NSTextAlignmentRight;
    self.rightTextField.frame = CGRectMake(origFrame.origin.x+imageWidth+self.textLabel.frame.size.width + 10, origFrame.origin.y, origFrame.size.width-imageWidth-self.textLabel.frame.size.width - 20, origFrame.size.height-1);
    
    
    [self setNeedsDisplay];
}
@end
