//
//  ViewController.m
//  LXToolBarDemo
//
//  Created by 李新星 on 15/11/10.
//  Copyright © 2015年 xx-li. All rights reserved.
//

#import "ViewController.h"
#import "LXToolBar.h"
#import <UIButton+LXLayout.h>

@interface ViewController () <LXToolBarDelegate>

@property (weak, nonatomic) IBOutlet LXToolBar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSArray * itemNames;


@end
 
@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"startviewDidLoad");
    
    _itemNames = @[@"区域", @"户型", @"面积", @"房型"];

    _toolBar.isShowSelectedTag = YES; 
    _toolBar.isDrawBottomSepLine = YES;
    _toolBar.isDrawTopSepLine = YES;
    _toolBar.isShowItemSeparatorLine = YES;
    _toolBar.backgroundColor = [UIColor whiteColor];
    _toolBar.separatorLineInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _toolBar.separatorImage = [UIImage imageNamed:@"sep_line"];
    _toolBar.itemSeparatorLineColor = [UIColor redColor];
    _toolBar.selectedIndex = 0;

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

#pragma mark - LXToolBarDelegate
//Item数量
- (NSInteger)numberOfItemsInToolBar:(LXToolBar *)toolBar {
    
    return _itemNames.count;
}

//创建每个Item
- (UIControl *)toolBar:(LXToolBar *)toolBar itemForIndex:(NSInteger)index {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.lx_subMargin = 5.0;
    button.lx_layoutType = LXButtonLayoutTypeImageRight;
    [button setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"up_arrow"] forState:UIControlStateSelected];
    [button setTitle:_itemNames[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return button;
}

//创建一个贴着ToolBar底部，点击后会滑动的滑块
- (UIView *)selectedTagViewForToolBar:(LXToolBar *)toolBar {
    //通过Frame可以设定此View的大小
    CGFloat widht = CGRectGetWidth([UIScreen mainScreen].bounds) / _itemNames.count - 5;
    UIView * tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widht, 3)];
    tagView.backgroundColor = [UIColor orangeColor];
    return tagView;
}

//选中Item执行的回调
- (void) toolBar:(LXToolBar *)toolBar didSelectItemAtIndex:(NSInteger)currentIndex previousSeleectedItemIndex:(NSInteger)previousIndex {
    NSLog(@"currentIndex %@  previousIndex %@", @(currentIndex), @(previousIndex));
    _label.text = _itemNames[currentIndex];
}

#pragma mark - Action
- (IBAction)buttonClick:(id)sender {
    //隐藏ToolBar的选中状态
    [_toolBar hiddenCurrentSelectedStatus];
}

- (IBAction)isShowSelectedTagSwitchValueChanged:(id)sender {
    UISwitch * curSwitch = (UISwitch *)sender;
    _toolBar.isShowSelectedTag = curSwitch.isOn;
    [_toolBar reloadAllItems];
}

- (IBAction)isShowItemsSeparatorLineSwitchValueChanged:(id)sender {
    UISwitch * curSwitch = (UISwitch *)sender;
    _toolBar.isShowItemSeparatorLine = curSwitch.isOn;
    [_toolBar reloadAllItems];
}
@end
