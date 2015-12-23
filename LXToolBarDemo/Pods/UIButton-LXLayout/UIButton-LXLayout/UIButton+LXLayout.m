//
//  UIButton+LXLayout.m
//  LXLayoutButtonDemo
//
//  Created by 李新星 on 15/11/11.
//  Copyright © 2015年 xx-li. All rights reserved.
//

#import "UIButton+LXLayout.h"
#import <objc/runtime.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define LX_MULTILINE_TEXTSIZE(text, font, maxSize, mode) (([text length] > 0) ? ([text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size) : (CGSizeZero));
#else
#define LX_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

@implementation UIButton (LXLayout)

#pragma mark -
+(void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method ovr_method = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method swz_method = class_getInstanceMethod([self class], @selector(lx_CustomLayoutSubviews));
        method_exchangeImplementations(ovr_method, swz_method);
    });
}

- (void)lx_CustomLayoutSubviews {
    
    [self lx_CustomLayoutSubviews];
    
    //将图片和文字综合放在视图最中央
    if (self.imageView.image && self.lx_layoutType != LXButtonLayoutTypeNone) {
        switch (self.lx_layoutType) {
            case LXButtonLayoutTypeImageLeft:
                [self layoutSubviewsByTypeLeft];
                break;
            case LXButtonLayoutTypeImageRight:
                [self layoutSubviewsByTypeRight];
                break;
            case LXButtonLayoutTypeImageBottom:
                [self layoutSubviewsByTypeBottom];
                break;
            case LXButtonLayoutTypeImageTop:
                [self layoutSubviewsByTypeTop];
                break;
            default:
                break;
        }
    
    }

}

#pragma mark - Public method
- (void) lx_layoutWithType:(LXButtonLayoutType)layoutType subMargin:(CGFloat)subMargin {
    self.lx_layoutType = layoutType;
    self.lx_subMargin = subMargin;
}

#pragma mark - Runtime Setter and getter
- (void)setLx_layoutType:(LXButtonLayoutType)lx_layoutType {
    if (self.lx_layoutType == lx_layoutType) {
        return;
    }
    objc_setAssociatedObject(self, @selector(lx_layoutType),[NSNumber numberWithInteger:lx_layoutType],OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setNeedsLayout];
}

- (LXButtonLayoutType)lx_layoutType {
    NSNumber * result = objc_getAssociatedObject(self, @selector(lx_layoutType));
    return [result integerValue];
}

- (void)setLx_subMargin:(CGFloat)lx_subMargin {
    if (self.lx_subMargin == lx_subMargin) {
        return;
    }
    objc_setAssociatedObject(self, @selector(lx_subMargin),[NSNumber numberWithFloat:lx_subMargin],OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)lx_subMargin {
    NSNumber * result = objc_getAssociatedObject(self, @selector(lx_subMargin));
    return [result floatValue];
}

#pragma mark - Layout Methods
- (void) layoutSubviewsByTypeLeft {
    
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat maxLabelWidth = CGRectGetWidth(self.frame) - imageWidth - self.lx_subMargin;
    CGSize maxSize = CGSizeMake(maxLabelWidth, self.titleLabel.font.lineHeight);
    
    CGSize labelSize = LX_MULTILINE_TEXTSIZE(self.titleLabel.text, self.titleLabel.font, maxSize, NSLineBreakByWordWrapping);
    CGFloat imageViewX = (CGRectGetWidth(self.frame) - labelSize.width - imageWidth - self.lx_subMargin) / 2.0;
    CGFloat imageViewY = (CGRectGetHeight(self.frame) - imageHeight) / 2.0;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageWidth, imageHeight);

    CGFloat labelX = CGRectGetMaxX(self.imageView.frame) + self.lx_subMargin;
    CGFloat labelY = (CGRectGetHeight(self.frame) - labelSize.height) / 2.0;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
}

- (void) layoutSubviewsByTypeRight {
    
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat imageWidth =self.imageView.image.size.width;
    
    CGFloat maxLabelWidth = CGRectGetWidth(self.frame) - imageWidth - self.lx_subMargin;
    CGSize maxSize = CGSizeMake(maxLabelWidth, self.titleLabel.font.lineHeight);
    
    CGSize labelSize = LX_MULTILINE_TEXTSIZE(self.titleLabel.text, self.titleLabel.font, maxSize, NSLineBreakByWordWrapping);
    CGFloat labelX = (CGRectGetWidth(self.frame) - labelSize.width - imageWidth - self.lx_subMargin) / 2.0;
    CGFloat labelY = (CGRectGetHeight(self.frame) - labelSize.height) / 2.0;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);

    CGFloat imageViewX = CGRectGetMaxX(self.titleLabel.frame) + self.lx_subMargin;
    CGFloat imageViewY = (CGRectGetHeight(self.frame) - imageHeight) / 2.0;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageWidth, imageHeight);
    
}

- (void)layoutSubviewsByTypeTop {
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGSize labelSize = LX_MULTILINE_TEXTSIZE(self.titleLabel.text, self.titleLabel.font, CGSizeMake(CGRectGetWidth(self.frame), self.titleLabel.font.lineHeight), NSLineBreakByWordWrapping);
    
    CGFloat imageViewX = (CGRectGetWidth(self.frame) - imageWidth) / 2.0;
    CGFloat imageViewY = (CGRectGetHeight(self.frame) - labelSize.height - imageHeight - self.lx_subMargin) / 2.0;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageWidth, imageHeight);

    CGFloat labelX = (CGRectGetWidth(self.frame) - labelSize.width) / 2.0;
    CGFloat labelY = CGRectGetMaxY(self.imageView.frame) + self.lx_subMargin;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
}

- (void) layoutSubviewsByTypeBottom {
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGSize labelSize = LX_MULTILINE_TEXTSIZE(self.titleLabel.text, self.titleLabel.font, CGSizeMake(CGRectGetWidth(self.frame), self.titleLabel.font.lineHeight), NSLineBreakByWordWrapping)
    CGFloat labelX = (CGRectGetWidth(self.frame) - labelSize.width) / 2.0;
    CGFloat labelY =  (CGRectGetHeight(self.frame) - labelSize.height - imageHeight - self.lx_subMargin) / 2.0;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);

    CGFloat imageViewX = (CGRectGetWidth(self.frame) - imageWidth) / 2.0;
    CGFloat imageViewY = CGRectGetMaxY(self.titleLabel.frame) + self.lx_subMargin;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageWidth, imageHeight);
}

@end
