//
//  ViewController.m
//  QFToolBarDemo
//
//  Created by 李新星 on 15-4-17.
//  Copyright (c) 2015年 深圳市开心房网网络科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "QFToolBar.h"
#import <LXLayoutButton.h>

@interface ViewController () <QFToolBarDelegate>

@property (weak, nonatomic) IBOutlet QFToolBar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSArray * itemNames;


@end
 
@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _toolBar.isShowSelectedTag = YES;
    _toolBar.isDrawBottomSepLine = YES;
    _toolBar.backgroundColor = [UIColor whiteColor];
    _toolBar.separatorLineInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _toolBar.separatorImage = [UIImage imageNamed:@"sep_line"];
    _toolBar.separatorLineColor = [UIColor redColor];
//    _toolBar.isShowSeparatorLine = NO;
    _itemNames = @[@"区域", @"户型", @"面积", @"房型"];
    
}

- (NSInteger)numberOfItemsInToolBar:(QFToolBar *)toolBar {
    
    return _itemNames.count;
}

- (UIControl *)toolBar:(QFToolBar *)toolBar itemForIndex:(NSInteger)index {
    
    LXLayoutButton * button = [LXLayoutButton buttonWithType:UIButtonTypeCustom];
    button.subMargin = 5.0;
    [button setImage:[UIImage imageNamed:@"down_tag"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"up_tag"] forState:UIControlStateSelected];
    [button setTitle:_itemNames[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return button;
}

- (void)toolBar:(QFToolBar *)toolBar didSelectItemAtIndex:(NSInteger)index {
    
    _label.text = _itemNames[index];
    
}

- (void)toolBar:(QFToolBar *)toolBar didDeselectItemAtIndex:(NSInteger)index {
    
}

- (UIView *)selectedTagViewForToolBar:(QFToolBar *)toolBar {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 3)];
    view.backgroundColor = [UIColor orangeColor];
    return view;
}

- (IBAction)buttonClick:(id)sender {
    
    [_toolBar selectItemAtIndex:0];
    
}

@end
