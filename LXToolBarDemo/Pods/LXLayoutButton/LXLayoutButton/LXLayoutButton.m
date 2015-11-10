//
//  CustomerManager
//
//  Created by 李新星 on 14-7-14.
//  Copyright (c) 2014年 xx-li. All rights reserved.
//


#import "LXLayoutButton.h"

#define X_MARGIN 0

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define LX_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define LX_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

@implementation LXLayoutButton

- (id)initWithFrame:(CGRect)frame subMargin:(CGFloat)subMargin  buttonType:(LXLayoutButtonType) buttonType {
    
    self = [super initWithFrame:frame];
    if (self) {
                
        _subMargin = subMargin;
        _layoutButtonType = buttonType;
        
        //默字体颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //默认字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
    
}

- (void)setSubMargin:(CGFloat)subMargin {
    
    if (_subMargin == subMargin) {
        return;
    }
    _subMargin = subMargin;
    [self layoutSubviews];
}

- (void)setLayoutButtonType:(LXLayoutButtonType)layoutButtonType {
    
    
    if (_layoutButtonType == layoutButtonType) {
        return;
    }
    
    _layoutButtonType = layoutButtonType;
    
    [self layoutSubviews];
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
//    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if (self.imageView.image) {
        
        if (self.layoutButtonType == LXLayoutButtonTypeLeft) {
            [self layoutSubviewsByTypeLeft];
        }
        else if (self.layoutButtonType == LXLayoutButtonTypeRight) {
            [self layoutSubviewsByTypeRight];
        }
        else if (self.layoutButtonType == LXLayoutButtonTypeBottom) {
            [self layoutSubviewsByTypeBottom];
        }
        else if (self.layoutButtonType == LXLayoutButtonTypeTop) {
            [self layoutSubviewsByTypeTop];
        }
    }
}

- (void) layoutSubviewsByTypeLeft {
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat maxLabelWidth = CGRectGetWidth(self.frame) - imageWidth - X_MARGIN * 2 - _subMargin;
    
    CGSize maxSize = CGSizeMake(maxLabelWidth, 0);
       //将图片和文字综合放在视图最中央
//    CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:maxSize];
    CGSize labelSize = LX_MULTILINE_TEXTSIZE(self.titleLabel.text, self.titleLabel.font, maxSize, NSLineBreakByWordWrapping);
    
    CGFloat imageViewX = (CGRectGetWidth(self.frame) - labelSize.width - imageWidth) / 2.0;
    CGFloat imageViewY = (CGRectGetHeight(self.frame) - imageHeight) / 2.0;
    //    _tagImageView.frame = CGRectMake(imageViewX, imageViewY, imageWidth, imageHeight);
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageWidth, imageHeight);
    
    
    //    CGFloat labelX = CGRectGetMaxX(_tagImageView.frame) + _subMargin;
    CGFloat labelX = CGRectGetMaxX(self.imageView.frame) + _subMargin;
    
    CGFloat labelY = (CGRectGetHeight(self.frame) - labelSize.height) / 2.0;
    //    _tagLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    
}

- (void) layoutSubviewsByTypeRight {
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat maxLabelWidth = CGRectGetWidth(self.frame) - imageWidth - X_MARGIN * 2 - _subMargin;
    
    CGSize maxSize = CGSizeMake(maxLabelWidth, 0);
    
    //将图片和文字综合放在视图最中央
    CGSize labelSize = LX_MULTILINE_TEXTSIZE(self.titleLabel.text, self.titleLabel.font, maxSize, NSLineBreakByWordWrapping);
    CGFloat labelX = (CGRectGetWidth(self.frame) - labelSize.width - imageWidth) / 2.0;
    CGFloat labelY = (CGRectGetHeight(self.frame) - labelSize.height) / 2.0;
    //    _tagLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    
    
    CGFloat imageViewX = CGRectGetMaxX(self.titleLabel.frame) + _subMargin;
    CGFloat imageViewY = (CGRectGetHeight(self.frame) - imageHeight) / 2.0;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageWidth, imageHeight);
}

- (void)layoutSubviewsByTypeTop {
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGSize labelSize = LX_MULTILINE_TEXTSIZE(self.titleLabel.text, self.titleLabel.font, CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)), NSLineBreakByWordWrapping);
    
    CGFloat imageViewX = (CGRectGetWidth(self.frame) - imageWidth) / 2.0;
    CGFloat imageViewY = (CGRectGetHeight(self.frame) - labelSize.height - imageHeight) / 2.0;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageWidth, imageHeight);
    
    CGFloat labelX = (CGRectGetWidth(self.frame) - labelSize.width) / 2.0;
    CGFloat labelY = CGRectGetMaxY(self.imageView.frame) + _subMargin;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    
}

- (void) layoutSubviewsByTypeBottom {
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGSize labelSize = LX_MULTILINE_TEXTSIZE(self.titleLabel.text, self.titleLabel.font, CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)), NSLineBreakByWordWrapping)
    
    CGFloat labelX = (CGRectGetWidth(self.frame) - labelSize.width) / 2.0;
    CGFloat labelY =  (CGRectGetHeight(self.frame) - labelSize.height - imageHeight) / 2.0;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
    
    CGFloat imageViewX = (CGRectGetWidth(self.frame) - imageWidth) / 2.0;
    CGFloat imageViewY = CGRectGetMaxY(self.titleLabel.frame) + _subMargin;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageWidth, imageHeight);
    
}


@end
