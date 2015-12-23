//
//  UIButton+LXLayout.h
//  LXLayoutButtonDemo
//
//  Created by 李新星 on 15/11/11.
//  Copyright © 2015年 xx-li. All rights reserved.
//

#import <UIKit/UIKit.h>

//UIButton重新布局的类型
typedef NS_ENUM(NSInteger, LXButtonLayoutType)
{
    LXButtonLayoutTypeNone                = 0,         //默认
    LXButtonLayoutTypeImageLeft           = 1,        //图片在左边
    LXButtonLayoutTypeImageRight          = 2,        //图片在右边
    LXButtonLayoutTypeImageTop            = 3,        //图片在上边
    LXButtonLayoutTypeImageBottom         = 4         //图片在下边
};

@interface UIButton (LXLayout)

/**
 *  文本和图片间的间距
 */
@property (assign, nonatomic) CGFloat lx_subMargin;

/**
 *  布局的类型
 */
@property (assign, nonatomic) LXButtonLayoutType lx_layoutType;

/**
 *  对按钮内部的图片和文本重新进行布局
 *
 *  @param layoutType 重新布局的类型
 *  @param subMargin  内部图片和文本之间的间距
 */
- (void) lx_layoutWithType:(LXButtonLayoutType)layoutType subMargin:(CGFloat)subMargin;

@end
