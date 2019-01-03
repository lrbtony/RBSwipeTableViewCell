# RBSwipeTableViewCell

![示例图片]https://github.com/lrbtony/RBSwipeTableViewCell/blob/master/RBSwipeTableViewCell/readmePicture.png


本框架使用自定义cell来实现系统的左滑竖排显示按钮，可自定义宽度，背景色，按钮的样式

使用方法：
直接拖拽RBSwipeTableViewCell.h和.m文件到项目，可以直接使用或者继承使用

关键代码：
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
    /*在RBContentView添加子控件*/
    [cell.RBContentView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(100, 60, 50, 30);
    
    
    
    
