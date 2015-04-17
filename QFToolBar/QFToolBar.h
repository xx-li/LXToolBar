//
//  QFToolBar.h
//  TestCodeAutoLayout
//
//  Created by 李新星 on 14-12-26.
//  Copyright (c) 2014年 深圳市开心房网网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QFToolBar;


@protocol QFToolBarDelegate<NSObject>

@required

- (NSInteger)numberOfItemsInToolBar:(QFToolBar *)toolBar;
- (UIControl *)toolBar:(QFToolBar *)toolBar itemForIndex:(NSInteger)index;

@optional

- (void)toolBar:(QFToolBar *)toolBar didSelectItemAtIndex:(NSInteger)index;
- (void)toolBar:(QFToolBar *)toolBar didDeselectItemAtIndex:(NSInteger)index;

- (UIView *)selectedTagViewForToolBar:(QFToolBar *)toolBar;

@end

/**
 *  自定义工具条，会等比例布局它上面的各个Item，并支持AutoLayout。为了保持灵活性，使用了Delegate。
 */
@interface QFToolBar : UIView

@property (weak, nonatomic) IBOutlet id <QFToolBarDelegate> delegate;

/**
 *  画一根下部的分割线,若设为Yes,则会将isDrawTopSepLine设为NO
 */
@property (assign, nonatomic) BOOL isDrawBottomSepLine;

/**
 *  画一根上部的分割线若设为Yes,则会将isDrawBottomSepLine设为NO
 */
@property (assign, nonatomic) BOOL isDrawTopSepLine;

@property (assign, nonatomic) BOOL isShowSelectedTag;

@property (assign, nonatomic) BOOL isShowSeparatorLine;

@property (assign, nonatomic) UIEdgeInsets separatorLineInsets;
@property (strong, nonatomic) UIColor *separatorLineColor;
@property (strong, nonatomic) UIImage *separatorImage;

- (void) reloadData;

// returns -1 or index
- (NSInteger)indexForSelectedItem;
- (void)selectItemAtIndex:(NSUInteger)index;

@end
