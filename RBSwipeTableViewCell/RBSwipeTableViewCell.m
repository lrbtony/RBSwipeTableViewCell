//
//  RBSwipeTableViewCell.m
//  RBSwipeTableViewCell
//
//  Created by lrb on 2018/12/29.
//  Copyright © 2018年 lrb. All rights reserved.
//

#import "RBSwipeTableViewCell.h"

#define RB_RBREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface RBSwipeTableViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, retain)UIView  *cellContentView;

@property (nonatomic, retain)UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign)CGFloat judgeWidth;
@property (nonatomic, assign)CGFloat rightfinalWidth;
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign,readwrite)BOOL isRightBtnShow;
@property (nonatomic, assign)BOOL otherCellIsOpen;
@property (nonatomic, assign)BOOL isHiding;
@property (nonatomic, assign)BOOL isShowing;
@end

@implementation RBSwipeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           withBtns:(NSArray *)arr
          tableView:(UITableView *)tableView cellIndexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rightBtnArr = [NSArray arrayWithArray:arr];
        self.superTableView = tableView;
        self.cellHeight = [_superTableView rectForRowAtIndexPath:indexPath].size.height;
        [self prepareForCell];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)prepareForCell{
    [self setBtns];
    [self setScrollView];
    [self addObserverEvent];
    [self addNotify];
}

#pragma mark prepareForReuser
- (void)prepareForReuse
{
    if ((_RBContentView.frame.origin.x == -_judgeWidth)) {
        if (!_isHiding) {
            [self cellWillHide];
            _isHiding = YES;
        }
    }
    _superTableView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temRect = _RBContentView.frame;
        temRect.origin.x = 0;
        _RBContentView.frame = temRect;
    } completion:^(BOOL finished) {
        [self cellDidHide];
        _isHiding = NO;
        _superTableView.userInteractionEnabled = YES;
    }];
    [super prepareForReuse];
}

#pragma mark setter
- (void)setRightBtnArr:(NSArray *)rightBtnArr{
    _rightBtnArr = rightBtnArr;
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    [self setBtns];
}

#pragma mark initCell

- (void)setBtns{
    if (_rightBtnArr.count>0) {
        [self processBtns];
    }
    else{
        return;
    }
}

- (void)processBtns{
    //竖排显示按钮
    CGFloat lastWidth = 0;
    int i = 0;
    
    for (UIButton *temBtn in _rightBtnArr)
    {
        //        temBtn.tag = i;
        CGRect temRect = temBtn.frame;
        temRect.origin.x = RB_RBREEN_WIDTH - temRect.size.width ;
        temRect.origin.y = self.cellHeight /  _rightBtnArr.count * i;
        temRect.size.height = self.cellHeight /  _rightBtnArr.count;
        temBtn.frame = temRect;
        lastWidth = temBtn.frame.size.width;
        
        if (!_judgeWidth || _judgeWidth < lastWidth) {
            _judgeWidth = lastWidth;
        }
        [temBtn addTarget:self action:@selector(cellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_RBContentView) {
            [self.contentView insertSubview:temBtn belowSubview:_RBContentView];
        }
        else{
            [self.contentView addSubview:temBtn];
        }
        i++;
    }
    _rightfinalWidth = lastWidth;
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setScrollView{
    if (_RBContentView) {
        return;
    }
    _RBContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RB_RBREEN_WIDTH, _cellHeight)];
    _RBContentView.backgroundColor = [UIColor whiteColor];

    [self.contentView addSubview:_RBContentView];
    self.contentView.clipsToBounds = YES;
    
    _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    _panGesture.delegate = self;
    [self.RBContentView addGestureRecognizer:_panGesture];
    
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTaped:)];
    _tapGesture.delegate = self;
    [self.RBContentView addGestureRecognizer:_tapGesture];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideBtn];
}

#pragma mark events,gesture and observe

- (void)addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotify:)
                                                 name:@"RB_CELL_SHOULDCLOSE"
                                               object:nil];
}

- (void)handleNotify:(NSNotification *)notify{
    if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"closeCell"]) {
        [self hideBtn];
        _otherCellIsOpen = NO;
    }
    else if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"otherCellIsOpen"]){
        _otherCellIsOpen = YES;
    }
    else if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"otherCellIsClose"])
    {
        _otherCellIsOpen = NO;
    }
}

- (void)addObserverEvent{
    [_superTableView addObserver:self
                      forKeyPath:@"contentOffset"
                         options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                         context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint oldpoint = [[change objectForKey:@"old"] CGPointValue];
        CGPoint newpoint = [[change objectForKey:@"new"] CGPointValue];
        if (oldpoint.y!=newpoint.y) {
            if ((_RBContentView.frame.origin.x == -_judgeWidth)) {
                [self hideBtn];
            }
        }
    }
}

- (void)cellTaped:(UITapGestureRecognizer *)recognizer{
    NSIndexPath *indexPath = [self.superTableView indexPathForCell:self];
    if (self.isRightBtnShow == NO) {
        [self.superTableView.delegate tableView:self.superTableView didSelectRowAtIndexPath:indexPath];
    }
    
    if (_otherCellIsOpen ) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RB_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"closeCell"}];
    }
}

- (void)handleGesture:(UIPanGestureRecognizer *)recognizer{
    if (_isShowing||_isHiding) {
        return;
    }
    CGPoint translation = [_panGesture translationInView:self];
    //    CGPoint location = [_panGesture locationInView:self];
    //    NSLog(@"translation----(%f)----loaction(%f)",translation.x,location.y);
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            if (fabs(translation.x)<fabs(translation.y)) {
                _superTableView.scrollEnabled = YES;
                return;
            }else{
                _superTableView.scrollEnabled = NO;
            }
            if (_otherCellIsOpen) {
                return;
            }
            //位移改变
            if (translation.x<0 && fabs(self.RBContentView.frame.origin.x) <= _rightfinalWidth) {
                if (fabs(self.RBContentView.frame.origin.x) == _rightfinalWidth) {
                    translation.x = _rightfinalWidth;
                }
                [self moveRBContentView:translation.x];
            }
            else if (translation.x>0){
                //拖动右移
                [self hideBtn];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            _superTableView.scrollEnabled = YES;
            if (_otherCellIsOpen&&!(_RBContentView.frame.origin.x == -_judgeWidth)) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RB_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"closeCell"}];
                return;
            }
            //end pan
            [self RBContentViewStop];
            break;
            
        case UIGestureRecognizerStateCancelled:
            _superTableView.scrollEnabled = YES;
            //cancell
            [self RBContentViewStop];
            break;
            
        default:
            break;
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)moveRBContentView:(CGFloat)offset{
    CGRect temRect = _RBContentView.frame;
    temRect.origin.x = (temRect.origin.x + offset);
    if (temRect.origin.x+(RB_RBREEN_WIDTH)/2.0<0) {
        temRect.origin.x = -RB_RBREEN_WIDTH/2.0;
    }
    if (temRect.origin.x>RB_RBREEN_WIDTH/2.0) {
        temRect.origin.x = RB_RBREEN_WIDTH/2.0;
    }
    _RBContentView.frame = temRect;
}

- (void)RBContentViewStop{
    if ((_RBContentView.frame.origin.x == -_judgeWidth)) {
        //btn is shown
        if (_RBContentView.frame.origin.x + _judgeWidth<0) {
            [self showBtn];
        }
        else
        {
            [self hideBtn];
        }
    }
    else{
        if (_RBContentView.frame.origin.x+_judgeWidth>0) {
            [self hideBtn];
        }
        else{
            [self showBtn];
        }
    }
}

#pragma mark showBtn hideBtn

- (void)showBtn{
    if (!(_RBContentView.frame.origin.x == -_judgeWidth)) {
        if (!_isShowing) {
            [self cellWillShow];
            _isShowing = YES;
        }
    }
    _superTableView.scrollEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect temRect = _RBContentView.frame;
        temRect.origin.x = -_rightfinalWidth;
        _RBContentView.frame = temRect;
    } completion:^(BOOL finished) {
        if (!_isRightBtnShow) {
            [self cellDidShow];
            _isShowing = NO;
            _isRightBtnShow = YES;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RB_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"otherCellIsOpen"}];
        _superTableView.scrollEnabled = YES;
    }];
}

- (void)hideBtn{
    if ((_RBContentView.frame.origin.x == -_judgeWidth)) {
        if (!_isHiding) {
            [self cellWillHide];
            _isHiding = YES;
        }
    }
    _superTableView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temRect = _RBContentView.frame;
        temRect.origin.x = 0;
        _RBContentView.frame = temRect;
    } completion:^(BOOL finished) {
        if (_isRightBtnShow) {
            [self cellDidHide];
            _isHiding = NO;
            _isRightBtnShow = NO;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RB_CELL_SHOULDCLOSE" object:nil userInfo:@{@"action":@"otherCellIsClose"}];
        _superTableView.userInteractionEnabled = YES;
    }];
}

#pragma delegate

- (void)cellWillHide{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnWillHide)]) {
        [_delegate cellOptionBtnWillHide];
    }
}

- (void)cellWillShow{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnWillShow)]) {
        [_delegate cellOptionBtnWillShow];
    }
}

- (void)cellDidShow{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnDidShow)]) {
        [_delegate cellOptionBtnDidShow];
    }
}

- (void)cellDidHide{
    if ([_delegate respondsToSelector:@selector(cellOptionBtnDidHide)]) {
        [_delegate cellOptionBtnDidHide];
    }
}

- (void)cellBtnClicked:(UIButton *)sender{
    NSIndexPath *indexPath = [self.superTableView indexPathForCell:self];
    if ([_delegate respondsToSelector:@selector(RBSwipeTableViewCelldidSelectBtnWithTag:andIndexPath:)]) {
        [_delegate RBSwipeTableViewCelldidSelectBtnWithTag:sender.tag andIndexPath:indexPath];
    }
    [self hideBtn];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)dealloc{
    [_superTableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RB_CELL_SHOULDCLOSE" object:nil];
}
@end
