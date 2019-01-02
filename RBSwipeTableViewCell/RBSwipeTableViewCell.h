//
//  RBSwipeTableViewCell.h
//  RBSwipeTableViewCell
//
//  Created by lrb on 2018/12/29.
//  Copyright © 2018年 lrb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RBSwipeTableViewCellDelegate <NSObject>

- (void)RBSwipeTableViewCelldidSelectBtnWithTag:(NSInteger)tag andIndexPath:(NSIndexPath *)indexpath;
@optional
- (void)cellOptionBtnWillShow;
- (void)cellOptionBtnWillHide;
- (void)cellOptionBtnDidShow;
- (void)cellOptionBtnDidHide;

@end

@interface RBSwipeTableViewCell : UITableViewCell

@property (nonatomic, weak)id<RBSwipeTableViewCellDelegate>delegate;

/**
 右边按钮数组
 */
@property (nonatomic, strong)NSArray *rightBtnArr;

/**
 背景色
 */
@property (nonatomic, strong)UIColor *cellBackGroundColor;

/**
 当使用这个类的时候,用这个RBContentView代替contentView
 */
@property (nonatomic, strong)UIView *RBContentView;
/**
把外层tableView赋值
 */
@property (nonatomic, strong)UITableView *superTableView;
/**
右边按钮是否显示
 */
@property (nonatomic, assign, readonly)BOOL isRightBtnShow;
/**
拖动手势
 */
@property (nonatomic, retain)UIPanGestureRecognizer *panGesture;


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           withBtns:(NSArray *)arr
          tableView:(UITableView *)tableView
      cellIndexPath:(NSIndexPath *)indexPath;

@end
