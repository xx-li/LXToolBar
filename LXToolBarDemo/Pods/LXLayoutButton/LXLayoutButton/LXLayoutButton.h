//
//  CustomerManager
//
//  Created by 李新星 on 14-7-14.
//  Copyright (c) 2014年 xx-li. All rights reserved.
//  


#import <UIKit/UIKit.h>

//按钮类型
typedef NS_ENUM(NSInteger, LXLayoutButtonType)
{
    LXLayoutButtonTypeLeft           = 0,        //图片在左边
    LXLayoutButtonTypeRight          = 1,        //图片在右边
    LXLayoutButtonTypeTop            = 2,        //图片在上边
    LXLayoutButtonTypeBottom         = 3         //图片在下边
};

@interface LXLayoutButton : UIButton

/**
 *  文本和图片间的间距
 */
@property (assign, nonatomic) CGFloat subMargin;

/**
 *  布局的类型
 */
@property (assign, nonatomic) LXLayoutButtonType layoutButtonType;            //类型

/**
 *  对按钮内部的图片和文本进行重新布局
 *
 *  @param frame      frame
 *  @param subMargin  文本和图片间的间距
 *  @param buttonType 布局的类型
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
          subMargin:(CGFloat)subMargin
         buttonType:(LXLayoutButtonType)buttonType;



@end
