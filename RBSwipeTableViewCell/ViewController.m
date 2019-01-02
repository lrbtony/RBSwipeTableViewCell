//
//  ViewController.m
//  RBSwipeTableViewCell
//
//  Created by lrb on 2018/12/29.
//  Copyright © 2018年 lrb. All rights reserved.
//

#import "ViewController.h"
#import "RBSwipeTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,RBSwipeTableViewCellDelegate>
@property (strong, nonatomic) UITableView *pullTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pullTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    [self.view addSubview:self.pullTableView];
    self.pullTableView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height  - 20);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}


#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RBSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    //可用系统自带按钮,也可以用自定义按钮
    UIButton *btn1;
    NSString * tmpStr = @"查询银行\n变更申请";
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 80)];
    btn1.titleLabel.numberOfLines = 0;
    btn1.backgroundColor = [self colorWithRGB:0x409bd8];
    btn1.tag = 0;
    [btn1 setTitle:tmpStr forState:UIControlStateNormal];
    
    UIButton *btn2;
    NSString * tmpStr1 = @"赎回/续期";
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 80)];
    btn2.titleLabel.numberOfLines = 0;
    [btn2 setTitle:tmpStr1 forState:UIControlStateNormal];
    btn2.tag = 1;
    btn2.backgroundColor = [self colorWithRGB:0xf48500];
    

    NSMutableArray *tmpArr = [[NSMutableArray alloc]initWithCapacity:2];
    if(btn1 != nil) {
        [tmpArr addObject:btn1];
    }
    if(btn2 != nil) {
        [tmpArr addObject:btn2];
    }

    if (cell == nil) {
        cell = [[RBSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"Cell1"
                                                       withBtns:nil
                                                      tableView:tableView
                                                  cellIndexPath:indexPath];
    }
    cell.delegate = self;
    cell.rightBtnArr = tmpArr;
    //控制拖拽动作
//    cell.panGesture.enabled = indexPath.row % 2;
    //可继承cell类,并重写initWithStyle方法制定子控件
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [NSString stringWithFormat:@"第%zd行",indexPath.row];
    [cell.RBContentView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(100, 60, 50, 30);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"选中了第%zd行",indexPath.row);
    
}

-(void)RBSwipeTableViewCelldidSelectBtnWithTag:(NSInteger)tag andIndexPath:(NSIndexPath *)indexpath {
    NSLog(@"选中了第%zd行第%zd个按钮",indexpath.row,tag);
}

#pragma mark - property
-(UITableView *)pullTableView {
    if (!_pullTableView) {
        _pullTableView = [[UITableView alloc]init];
        
    }
    return _pullTableView;
}
@end
